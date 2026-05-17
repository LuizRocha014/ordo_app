import 'package:flutter/foundation.dart';

import '../../domain/entities/checklist_item.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/os_status.dart';
import '../../domain/entities/service_order.dart';
import '../../domain/usecases/create_service_order.dart';
import '../../domain/usecases/get_checklist_template.dart';

/// Estado do formulário de Nova OS — mantém os campos digitados e
/// dispara a criação ao final.
class NovaOsProvider extends ChangeNotifier {
  final CreateServiceOrder _create;
  final GetChecklistTemplate _template;

  NovaOsProvider(this._create, this._template);

  String clientName = '';
  String clientPhone = '';
  Map<String, String> equipmentFields = {};
  String problem = '';

  bool _saving = false;
  String? _error;
  ServiceOrder? _created;
  List<ChecklistItem> _templateItems = const [];

  bool get saving => _saving;
  String? get error => _error;
  ServiceOrder? get created => _created;
  List<ChecklistItem> get templateItems => _templateItems;

  void reset() {
    clientName = '';
    clientPhone = '';
    equipmentFields = {};
    problem = '';
    _created = null;
    _error = null;
    _templateItems = const [];
    notifyListeners();
  }

  Future<void> loadTemplate(String shopTypeId) async {
    final r = await _template(shopTypeId);
    r.fold(
      onSuccess: (items) => _templateItems = items,
      onFailure: (f) => _error = f.message,
    );
    notifyListeners();
  }

  /// Monta o `title` da OS a partir dos campos de equipamento + problema.
  ///
  /// Estratégia simples: pega o primeiro campo não-vazio (placa, modelo,
  /// IMEI etc.) como prefixo e o problema como sufixo curto.
  String _buildTitle(String shopId) {
    final modelo = equipmentFields.values
        .firstWhere((v) => v.trim().isNotEmpty, orElse: () => '');
    final problemaCurto = problem.length > 40
        ? '${problem.substring(0, 40)}…'
        : problem;
    if (modelo.isEmpty) return problemaCurto.isEmpty ? 'OS aberta' : problemaCurto;
    if (problemaCurto.isEmpty) return modelo;
    return '$modelo — $problemaCurto';
  }

  Future<bool> submit({required String shopTypeId}) async {
    _saving = true;
    _error = null;
    notifyListeners();

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
      checklist: _templateItems,
    );

    final result = await _create(CreateServiceOrderParams(draft));
    final ok = result.fold(
      onSuccess: (o) {
        _created = o;
        return true;
      },
      onFailure: (f) {
        _error = f.message;
        return false;
      },
    );

    _saving = false;
    notifyListeners();
    return ok;
  }
}
