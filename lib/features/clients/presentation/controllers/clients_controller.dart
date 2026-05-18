import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../service_order/domain/entities/client.dart';
import '../../domain/usecases/create_client.dart';
import '../../domain/usecases/list_clients.dart';

/// Estado da lista de clientes.
///
/// `items` é a lista filtrada exibida na tela; `_all` é a fonte da
/// verdade carregada do repo, mantida para que `setQuery()` possa
/// filtrar sem refazer a chamada.
class ClientsController extends GetxController {
  final ListClients _list;
  final CreateClient _create;

  ClientsController(this._list, this._create);

  final RxBool loading = false.obs;
  final RxBool saving = false.obs;
  final RxnString error = RxnString();
  final RxList<Client> _all = <Client>[].obs;
  final RxList<Client> items = <Client>[].obs;
  final RxString query = ''.obs;
  final Rxn<Client> lastCreated = Rxn<Client>();

  Future<void> load() async {
    loading.value = true;
    error.value = null;

    final result = await _list(const NoParams());
    result.fold(
      onSuccess: (list) {
        _all.assignAll(list);
        _applyQuery();
      },
      onFailure: (f) => error.value = f.message,
    );

    loading.value = false;
  }

  void setQuery(String q) {
    query.value = q;
    _applyQuery();
  }

  void _applyQuery() {
    final q = removeDiacritics(query.value.toLowerCase()).trim();
    if (q.isEmpty) {
      items.assignAll(_all);
      return;
    }
    items.assignAll(_all.where((c) {
      final name = removeDiacritics(c.name.toLowerCase());
      final phone = c.phone.toLowerCase();
      return name.contains(q) || phone.contains(q);
    }));
  }

  Future<bool> create({
    required String name,
    required String phone,
    String? notes,
  }) async {
    saving.value = true;
    error.value = null;

    final result = await _create(
      CreateClientParams(name: name, phone: phone, notes: notes),
    );
    final ok = result.fold(
      onSuccess: (c) {
        lastCreated.value = c;
        return true;
      },
      onFailure: (f) {
        error.value = f.message;
        return false;
      },
    );

    if (ok) await load();
    saving.value = false;
    return ok;
  }
}
