import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/entities/timeline_event.dart';
import '../../domain/repositories/service_order_repository.dart';
import '../datasources/service_order_local_datasource.dart';
import '../models/service_order_model.dart';
import 'package:diacritic/diacritic.dart';

class ServiceOrderRepositoryImpl implements ServiceOrderRepository {
  final ServiceOrderLocalDataSource _local;

  const ServiceOrderRepositoryImpl(this._local);

  @override
  Future<Result<List<ServiceOrder>>> list(ServiceOrderFilter filter) async {
    try {
      final all = await _local.list();
      Iterable<ServiceOrderModel> result = all;

      if (filter.status != null) {
        result = result.where((o) => o.status == filter.status);
      }
      final q = filter.query?.trim();
      if (q != null && q.isNotEmpty) {
        final needle = removeDiacritics(q.toLowerCase());
        result = result.where((o) {
          final haystack = removeDiacritics(
            '${o.title} ${o.client.name} #${o.id}'.toLowerCase(),
          );
          return haystack.contains(needle);
        });
      }
      return Success(result.toList());
    } catch (e) {
      return FailureResult(
        UnexpectedFailure('Não consegui carregar as OS.', cause: e),
      );
    }
  }

  @override
  Future<Result<ServiceOrder>> getById(String id) async {
    try {
      final order = await _local.getById(id);
      if (order == null) {
        return FailureResult(NotFoundFailure('OS #$id não encontrada.'));
      }
      return Success(order);
    } catch (e) {
      return FailureResult(
        UnexpectedFailure('Não consegui carregar a OS.', cause: e),
      );
    }
  }

  @override
  Future<Result<ServiceOrder>> create(ServiceOrder order) async {
    try {
      final nextId = order.id.isNotEmpty ? order.id : await _local.nextId();
      final stored = ServiceOrderModel.fromEntity(
        order.copyWith().copyWith(updatedAt: DateTime.now()),
      );
      final finalOrder = ServiceOrderModel(
        id: nextId,
        title: stored.title,
        category: stored.category,
        client: stored.client,
        problem: stored.problem,
        status: stored.status,
        valueCents: stored.valueCents,
        openedAt: stored.openedAt,
        updatedAt: stored.updatedAt,
        checklist: stored.checklist,
        timeline: [
          TimelineEvent(
            id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
            when: DateTime.now(),
            description: 'OS aberta.',
            author: 'Você',
            accent: true,
          ),
          ...stored.timeline,
        ],
        photoIds: stored.photoIds,
      );
      await _local.upsert(finalOrder);
      return Success(finalOrder);
    } catch (e) {
      return FailureResult(
        UnexpectedFailure('Não consegui salvar a OS.', cause: e),
      );
    }
  }

  @override
  Future<Result<ServiceOrder>> updateStatus(String id, OsStatus status) async {
    try {
      final existing = await _local.getById(id);
      if (existing == null) {
        return FailureResult(NotFoundFailure('OS #$id não encontrada.'));
      }
      final updated = ServiceOrderModel.fromEntity(
        existing.copyWith(
          status: status,
          updatedAt: DateTime.now(),
          timeline: [
            TimelineEvent(
              id: 'ev-${DateTime.now().millisecondsSinceEpoch}',
              when: DateTime.now(),
              description: 'Status alterado para ${status.label}.',
              author: 'Você',
              accent: true,
            ),
            ...existing.timeline,
          ],
        ),
      );
      await _local.upsert(updated);
      return Success(updated);
    } catch (e) {
      return FailureResult(
        UnexpectedFailure('Não consegui atualizar o status.', cause: e),
      );
    }
  }

  @override
  Future<Result<ServiceOrder>> toggleChecklistItem(
    String orderId,
    String itemId,
  ) async {
    try {
      final existing = await _local.getById(orderId);
      if (existing == null) {
        return FailureResult(NotFoundFailure('OS #$orderId não encontrada.'));
      }
      final newList = existing.checklist.map((c) {
        if (c.id != itemId) return c;
        final newDone = !c.done;
        return c.copyWith(
          done: newDone,
          photoCount: newDone && c.photoCount == 0 ? 1 : c.photoCount,
        );
      }).toList();
      final updated = ServiceOrderModel.fromEntity(
        existing.copyWith(checklist: newList, updatedAt: DateTime.now()),
      );
      await _local.upsert(updated);
      return Success(updated);
    } catch (e) {
      return FailureResult(
        UnexpectedFailure('Não consegui atualizar o checklist.', cause: e),
      );
    }
  }

  @override
  Future<Result<List<ChecklistItem>>> templateFor(String shopTypeId) async {
    try {
      return Success(await _local.templateFor(shopTypeId));
    } catch (e) {
      return FailureResult(
        UnexpectedFailure('Não consegui carregar o template.', cause: e),
      );
    }
  }
}
