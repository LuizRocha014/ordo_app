import 'package:get/get.dart';

import '../../../clients/domain/usecases/create_client.dart';
import '../../domain/entities/checklist_item.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/usecases/create_service_order.dart';
import '../../domain/usecases/get_checklist_template.dart';

/// Estado do formulário de Nova OS — mantém os campos digitados e
/// dispara a criação ao final.
///
/// Os campos são mutáveis comuns (não-Rx) porque vivem em `TextField`
/// controllers e só importam no momento de `submit()`. Os flags
/// reativos (`saving`, `error`, `created`) sim são `.obs`.
///
/// Ao submeter, primeiro registra o cliente via `CreateClient` (assim
/// ele aparece na lista de clientes mesmo se a OS for o primeiro
/// contato) e depois usa o cliente retornado na OS.
class NovaOsController extends GetxController {
  final CreateServiceOrder _create;
  final GetChecklistTemplate _template;
  final CreateClient _createClient;

  NovaOsController(this._create, this._template, this._createClient);

  String clientName = '';
  String clientPhone = '';
  Map<String, String> equipmentFields = {};
  String problem = '';

  final RxBool saving = false.obs;
  final RxnString error = RxnString();
  final Rxn<ServiceOrder> created = Rxn<ServiceOrder>();
  final RxList<ChecklistItem> templateItems = <ChecklistItem>[].obs;

  void reset() {
    clientName = '';
    clientPhone = '';
    equipmentFields = {};
    problem = '';
    created.value = null;
    error.value = null;
    templateItems.clear();
  }

  Future<void> loadTemplate(String shopTypeId) async {
    final r = await _template(shopTypeId);
    r.fold(
      onSuccess: templateItems.assignAll,
      onFailure: (f) => error.value = f.message,
    );
  }

  /// Monta o `title` da OS a partir dos campos de equipamento + problema.
  String _buildTitle(String shopId) {
    final modelo = equipmentFields.values
        .firstWhere((v) => v.trim().isNotEmpty, orElse: () => '');
    final problemaCurto =
        problem.length > 40 ? '${problem.substring(0, 40)}…' : problem;
    if (modelo.isEmpty) {
      return problemaCurto.isEmpty ? 'OS aberta' : problemaCurto;
    }
    if (problemaCurto.isEmpty) return modelo;
    return '$modelo — $problemaCurto';
  }

  Future<bool> submit({required String shopTypeId}) async {
    saving.value = true;
    error.value = null;

    final clientResult = await _createClient(
      CreateClientParams(
        name: clientName.trim(),
        phone: clientPhone.trim(),
      ),
    );
    final Client? client = clientResult.fold(
      onSuccess: (c) => c,
      onFailure: (f) {
        error.value = f.message;
        return null;
      },
    );
    if (client == null) {
      saving.value = false;
      return false;
    }

    final now = DateTime.now();
    final draft = ServiceOrder(
      id: '',
      title: _buildTitle(shopTypeId),
      category: shopTypeId,
      client: client,
      problem: problem.trim(),
      status: OsStatus.aberta,
      valueCents: 0,
      openedAt: now,
      updatedAt: now,
      checklist: templateItems.toList(),
    );

    final result = await _create(CreateServiceOrderParams(draft));
    final ok = result.fold(
      onSuccess: (o) {
        created.value = o;
        return true;
      },
      onFailure: (f) {
        error.value = f.message;
        return false;
      },
    );

    saving.value = false;
    return ok;
  }
}
