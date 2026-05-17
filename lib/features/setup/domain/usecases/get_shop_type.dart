import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop_type.dart';
import '../repositories/shop_repository.dart';

class GetShopType extends UseCase<ShopType?, NoParams> {
  final ShopRepository _repo;
  const GetShopType(this._repo);

  @override
  Future<Result<ShopType?>> call(NoParams params) => _repo.getShopType();
}
