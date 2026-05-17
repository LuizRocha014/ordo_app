/// Tipo de oficina configurado no primeiro launch.
///
/// Cada oficina trabalha com **um tipo** de serviço — isso simplifica o
/// fluxo de Nova OS e seleciona o checklist correto automaticamente.
enum ShopType {
  carro(
    id: 'carro',
    label: 'Carros',
    productNoun: 'carro',
    productNounPlural: 'carros',
    icon: 'car',
    shopName: 'Ordo Auto',
    shopSubtitle: 'mecânica + diagnóstico',
  ),
  moto(
    id: 'moto',
    label: 'Motos',
    productNoun: 'moto',
    productNounPlural: 'motos',
    icon: 'bike',
    shopName: 'Ordo Motos',
    shopSubtitle: 'manutenção e revisão',
  ),
  celular(
    id: 'celular',
    label: 'Celulares',
    productNoun: 'celular',
    productNounPlural: 'celulares',
    icon: 'smartphone',
    shopName: 'Ordo Eletrônica',
    shopSubtitle: 'reparo de smartphones',
  ),
  notebook(
    id: 'notebook',
    label: 'Notebooks',
    productNoun: 'notebook',
    productNounPlural: 'notebooks',
    icon: 'laptop',
    shopName: 'Ordo Tech',
    shopSubtitle: 'assistência de notebooks',
  ),
  eletrodomestico(
    id: 'eletrodomestico',
    label: 'Eletrodomésticos',
    productNoun: 'aparelho',
    productNounPlural: 'aparelhos',
    icon: 'washing-machine',
    shopName: 'Ordo Eletro',
    shopSubtitle: 'reparo de eletrodomésticos',
  );

  const ShopType({
    required this.id,
    required this.label,
    required this.productNoun,
    required this.productNounPlural,
    required this.icon,
    required this.shopName,
    required this.shopSubtitle,
  });

  final String id;
  final String label;
  final String productNoun;
  final String productNounPlural;
  final String icon;
  final String shopName;
  final String shopSubtitle;

  static ShopType? fromId(String? id) {
    if (id == null) return null;
    for (final t in ShopType.values) {
      if (t.id == id) return t;
    }
    return null;
  }
}
