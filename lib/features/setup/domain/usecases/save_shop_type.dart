import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/shop_type.dart';
import '../repositories/shop_repository.dart';

class SaveShopType extends UseCase<void, ShopType> {
  final ShopRepository _repo;
  const SaveShopType(this._repo);

  @override
  Future<Result<void>> call(ShopType params) => _repo.saveShopType(params);
}
