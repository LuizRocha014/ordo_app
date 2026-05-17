import '../../domain/entities/checklist_item.dart';
import '../models/checklist_item_model.dart';
import '../models/service_order_model.dart';

/// Datasource local — mantém uma "tabela" em memória de OS.
///
/// É **a única implementação** desta abstração até existir um backend HTTP.
/// Quando esse momento chegar, criar `ServiceOrderRemoteDataSource` e
/// trocar/compor no `repository_impl` sem mexer no domínio.
abstract class ServiceOrderLocalDataSource {
  Future<List<ServiceOrderModel>> list();
  Future<ServiceOrderModel?> getById(String id);
  Future<ServiceOrderModel> upsert(ServiceOrderModel order);
  Future<List<ChecklistItem>> templateFor(String shopTypeId);
  Future<String> nextId();
}

class InMemoryServiceOrderDataSource implements ServiceOrderLocalDataSource {
  final Map<String, ServiceOrderModel> _store = {};
  int _seq = 1284;

  InMemoryServiceOrderDataSource({List<ServiceOrderModel>? seed}) {
    if (seed != null) {
      for (final s in seed) {
        _store[s.id] = s;
      }
    }
  }

  @override
  Future<List<ServiceOrderModel>> list() async {
    final list = _store.values.toList();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  @override
  Future<ServiceOrderModel?> getById(String id) async => _store[id];

  @override
  Future<ServiceOrderModel> upsert(ServiceOrderModel order) async {
    _store[order.id] = order;
    return order;
  }

  @override
  Future<String> nextId() async {
    _seq += 1;
    return _seq.toString().padLeft(4, '0');
  }

  @override
  Future<List<ChecklistItem>> templateFor(String shopTypeId) async {
    return ChecklistTemplates.forShop(shopTypeId)
        .map((e) => ChecklistItemModel(id: e.$1, label: e.$2))
        .toList();
  }
}

/// Templates fixos de checklist por categoria. Em produção, esses
/// templates viriam de uma tabela editável (ou do backend).
class ChecklistTemplates {
  const ChecklistTemplates._();

  static List<(String, String)> forShop(String shopTypeId) {
    switch (shopTypeId) {
      case 'carro':
        return const [
          ('hodometro', 'Foto do hodômetro'),
          ('lateral_d', 'Foto da lateral direita'),
          ('lateral_e', 'Foto da lateral esquerda'),
          ('traseira', 'Foto da traseira'),
          ('motor', 'Foto do motor'),
          ('combustivel', 'Nível de combustível'),
          ('riscos', 'Riscos e avarias visíveis'),
        ];
      case 'moto':
        return const [
          ('hodometro', 'Foto do hodômetro'),
          ('lateral_d', 'Foto da lateral direita'),
          ('lateral_e', 'Foto da lateral esquerda'),
          ('motor', 'Foto do motor'),
          ('combustivel', 'Nível de combustível'),
          ('avarias', 'Avarias visíveis'),
        ];
      case 'celular':
        return const [
          ('frente', 'Foto da frente'),
          ('verso', 'Foto do verso'),
          ('tela_on', 'Tela ligada (se possível)'),
          ('imei', 'Foto do IMEI / serial'),
          ('avarias', 'Riscos / amassados'),
          ('acessorios', 'Acessórios entregues'),
        ];
      case 'notebook':
        return const [
          ('tampa', 'Foto da tampa'),
          ('teclado', 'Foto do teclado'),
          ('tela_on', 'Tela ligada (se possível)'),
          ('portas', 'Foto das portas / conectores'),
          ('serial', 'Foto do serial'),
          ('avarias', 'Riscos / amassados'),
          ('acessorios', 'Acessórios entregues (fonte, mouse)'),
        ];
      case 'eletrodomestico':
        return const [
          ('frente', 'Foto da frente'),
          ('etiqueta', 'Foto da etiqueta de identificação'),
          ('avarias', 'Avarias visíveis'),
          ('acessorios', 'Acessórios entregues'),
        ];
      default:
        return const [
          ('estado_geral', 'Estado geral'),
          ('serial', 'Identificação do equipamento'),
          ('avarias', 'Avarias visíveis'),
        ];
    }
  }
}
