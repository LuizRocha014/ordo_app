import 'package:componentes_lr/componentes_lr.dart';

/// Acesso ao SharedPreferences via `componentes_lr` para persistir o
/// tipo de oficina escolhido na configuração inicial.
abstract class ShopLocalDataSource {
  Future<String?> readShopTypeId();
  Future<void> writeShopTypeId(String id);
}

class ShopLocalDataSourceImpl implements ShopLocalDataSource {
  static const _key = 'ordo.shop_type.id';

  @override
  Future<String?> readShopTypeId() async {
    return sharedPreferences.getString(_key);
  }

  @override
  Future<void> writeShopTypeId(String id) async {
    await sharedPreferences.setString(_key, id);
  }
}
