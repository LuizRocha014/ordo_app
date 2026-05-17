import 'checklist_item.dart';
import 'client.dart';
import 'os_status.dart';
import 'timeline_event.dart';

/// Ordem de Serviço — entidade central do domínio.
///
/// `id` é o número da OS (`#0182`) zero-padded em 4 dígitos. `valueCents`
/// fica em centavos pra evitar erros de ponto flutuante.
class ServiceOrder {
  final String id;
  final String title;
  final String category;
  final Client client;
  final String problem;
  final OsStatus status;
  final int valueCents;
  final DateTime openedAt;
  final DateTime updatedAt;
  final List<ChecklistItem> checklist;
  final List<TimelineEvent> timeline;
  final List<String> photoIds;

  const ServiceOrder({
    required this.id,
    required this.title,
    required this.category,
    required this.client,
    required this.problem,
    required this.status,
    required this.valueCents,
    required this.openedAt,
    required this.updatedAt,
    this.checklist = const [],
    this.timeline = const [],
    this.photoIds = const [],
  });

  ServiceOrder copyWith({
    String? title,
    String? category,
    Client? client,
    String? problem,
    OsStatus? status,
    int? valueCents,
    DateTime? updatedAt,
    List<ChecklistItem>? checklist,
    List<TimelineEvent>? timeline,
    List<String>? photoIds,
  }) {
    return ServiceOrder(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      client: client ?? this.client,
      problem: problem ?? this.problem,
      status: status ?? this.status,
      valueCents: valueCents ?? this.valueCents,
      openedAt: openedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      checklist: checklist ?? this.checklist,
      timeline: timeline ?? this.timeline,
      photoIds: photoIds ?? this.photoIds,
    );
  }

  /// Quantos itens do checklist já estão concluídos.
  int get checklistDoneCount => checklist.where((c) => c.done).length;
}
