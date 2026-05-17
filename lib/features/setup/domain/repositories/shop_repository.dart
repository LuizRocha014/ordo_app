import '../../../../core/result/result.dart';
import '../entities/shop_type.dart';

abstract class ShopRepository {
  /// Tipo configurado ou `null` se ainda não foi escolhido.
  Future<Result<ShopType?>> getShopType();

  Future<Result<void>> saveShopType(ShopType type);
}
