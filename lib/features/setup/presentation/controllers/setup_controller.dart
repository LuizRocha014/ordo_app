import 'package:get/get.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/shop_type.dart';
import '../../domain/usecases/get_shop_type.dart';
import '../../domain/usecases/save_shop_type.dart';

/// Estado da configuração inicial (qual tipo de oficina o usuário rodou
/// o app sob).
///
/// `current` é a fonte da verdade pro app inteiro depois do setup —
/// outros controllers leem ele via `Get.find<SetupController>().current.value`.
class SetupController extends GetxController {
  final GetShopType _get;
  final SaveShopType _save;

  SetupController(this._get, this._save);

  final Rxn<ShopType> current = Rxn<ShopType>();
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  bool get isConfigured => current.value != null;

  Future<void> bootstrap() async {
    loading.value = true;
    error.value = null;

    final result = await _get(const NoParams());
    result.fold(
      onSuccess: (shop) {
        current.value = shop;
      },
      onFailure: (f) {
        error.value = f.message;
      },
    );

    loading.value = false;
  }

  Future<bool> pick(ShopType type) async {
    loading.value = true;
    error.value = null;

    final result = await _save(type);
    final ok = result.fold(
      onSuccess: (_) {
        current.value = type;
        return true;
      },
      onFailure: (f) {
        error.value = f.message;
        return false;
      },
    );

    loading.value = false;
    return ok;
  }
}
