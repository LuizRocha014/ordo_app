import '../../../service_order/domain/entities/address.dart';
import '../../../service_order/domain/entities/client.dart';

/// Datasource local — mantém uma "tabela" em memória de clientes.
abstract class ClientLocalDataSource {
  Future<List<Client>> list();
  Future<Client?> getById(String id);
  Future<Client> create({
    required String name,
    required String phone,
    String? email,
    String? cpf,
    Address? address,
    String? notes,
  });
}

/// Implementação in-memory. Seedada no startup com os clientes
/// embarcados nas OS de demonstração — assim a lista já abre com
/// dados quando o app sobe.
class InMemoryClientDataSource implements ClientLocalDataSource {
  final Map<String, Client> _store = {};
  int _seq = 0;

  InMemoryClientDataSource({List<Client>? seed}) {
    if (seed != null) {
      for (final c in seed) {
        _store[c.id] = c;
        final num = int.tryParse(c.id.replaceFirst('cli-', ''));
        if (num != null && num > _seq) _seq = num;
      }
    }
  }

  @override
  Future<List<Client>> list() async {
    final list = _store.values.toList();
    list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return list;
  }

  @override
  Future<Client?> getById(String id) async => _store[id];

  @override
  Future<Client> create({
    required String name,
    required String phone,
    String? email,
    String? cpf,
    Address? address,
    String? notes,
  }) async {
    _seq += 1;
    final c = Client(
      id: 'cli-$_seq',
      name: name,
      phone: phone,
      email: email,
      cpf: cpf,
      address: address,
    );
    _store[c.id] = c;
    return c;
  }
}
