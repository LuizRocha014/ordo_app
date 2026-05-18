import '../../../../core/result/result.dart';
import '../../../service_order/domain/entities/address.dart';
import '../../../service_order/domain/entities/client.dart';

abstract class ClientRepository {
  Future<Result<List<Client>>> list();

  Future<Result<Client>> getById(String id);

  Future<Result<Client>> create({
    required String name,
    required String phone,
    String? email,
    String? cpf,
    Address? address,
    String? notes,
  });
}
