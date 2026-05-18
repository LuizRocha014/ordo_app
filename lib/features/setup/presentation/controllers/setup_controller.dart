import 'package:get/get.dart';

import '../../domain/entities/shop_type.dart';

/// Tipo de oficina ativo no app.
///
/// Fonte de verdade pro resto do app: páginas leem o shop atual via
/// `Get.find<SetupController>().current.value`. O valor é fixo em
/// `ShopType.celular` — não há mais tela de escolha.
class SetupController extends GetxController {
  final Rxn<ShopType> current = Rxn<ShopType>();

  void bootstrap() {
    current.value = ShopType.celular;
  }
}
