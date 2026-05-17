import '../../../../core/result/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/checklist_item.dart';
import '../repositories/service_order_repository.dart';

class GetChecklistTemplate extends UseCase<List<ChecklistItem>, String> {
  final ServiceOrderRepository _repo;
  const GetChecklistTemplate(this._repo);

  @override
  Future<Result<List<ChecklistItem>>> call(String params) =>
      _repo.templateFor(params);
}
