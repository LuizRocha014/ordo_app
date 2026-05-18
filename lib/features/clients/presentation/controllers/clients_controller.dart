import 'package:diacritic/diacritic.dart';
import 'package:get/get.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../service_order/domain/entities/address.dart';
import '../../../service_order/domain/entities/client.dart';
import '../../domain/entities/cep_lookup_result.dart';
import '../../domain/usecases/create_client.dart';
import '../../domain/usecases/list_clients.dart';
import '../../domain/usecases/lookup_cep.dart';

/// Estado da lista de clientes + ações de cadastro.
///
/// `items` é a lista filtrada exibida na tela; `_all` é a fonte da
/// verdade carregada do repo. `lookupCep` consulta ViaCEP para
/// auto-preencher o endereço no formulário.
class ClientsController extends GetxController {
  final ListClients _list;
  final CreateClient _create;
  final LookupCep _lookupCep;

  ClientsController(this._list, this._create, this._lookupCep);

  final RxBool loading = false.obs;
  final RxBool saving = false.obs;
  final RxBool cepLoading = false.obs;
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
      final cpf = c.cpf?.toLowerCase() ?? '';
      final email = c.email?.toLowerCase() ?? '';
      return name.contains(q) ||
          phone.contains(q) ||
          cpf.contains(q) ||
          email.contains(q);
    }));
  }

  Future<CepLookupResult?> lookupCep(String cep) async {
    cepLoading.value = true;
    error.value = null;
    final result = await _lookupCep(cep);
    final data = result.fold(
      onSuccess: (data) => data,
      onFailure: (f) {
        error.value = f.message;
        return null;
      },
    );
    cepLoading.value = false;
    return data;
  }

  Future<bool> create({
    required String name,
    required String phone,
    String? email,
    String? cpf,
    Address? address,
    String? notes,
  }) async {
    saving.value = true;
    error.value = null;

    final result = await _create(
      CreateClientParams(
        name: name,
        phone: phone,
        email: email,
        cpf: cpf,
        address: address,
        notes: notes,
      ),
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
