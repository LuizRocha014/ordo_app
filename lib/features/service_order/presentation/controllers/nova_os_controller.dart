import 'package:get/get.dart';

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
class NovaOsController extends GetxController {
  final CreateServiceOrder _create;
  final GetChecklistTemplate _template;

  NovaOsController(this._create, this._template);

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

    final now = DateTime.now();
    final draft = ServiceOrder(
      id: '',
      title: _buildTitle(shopTypeId),
      category: shopTypeId,
      client: Client(
        id: 'cli-${now.millisecondsSinceEpoch}',
        name: clientName.trim(),
        phone: clientPhone.trim(),
      ),
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
