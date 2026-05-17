import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/shop_type.dart';
import '../../domain/repositories/shop_repository.dart';
import '../datasources/shop_local_datasource.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopLocalDataSource _local;

  const ShopRepositoryImpl(this._local);

  @override
  Future<Result<ShopType?>> getShopType() async {
    try {
      final id = await _local.readShopTypeId();
      return Success(ShopType.fromId(id));
    } catch (e) {
      return FailureResult(
        StorageFailure('Não consegui ler o tipo de oficina.', cause: e),
      );
    }
  }

  @override
  Future<Result<void>> saveShopType(ShopType type) async {
    try {
      await _local.writeShopTypeId(type.id);
      return const Success(null);
    } catch (e) {
      return FailureResult(
        StorageFailure('Não consegui salvar o tipo de oficina.', cause: e),
      );
    }
  }
}
