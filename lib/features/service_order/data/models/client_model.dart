import '../../domain/entities/client.dart';
import 'address_model.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.name,
    required super.phone,
    super.email,
    super.cpf,
    super.address,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
        id: json['id'] as String,
        name: json['name'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String?,
        cpf: json['cpf'] as String?,
        address: json['address'] != null
            ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        if (email != null) 'email': email,
        if (cpf != null) 'cpf': cpf,
        if (address != null) 'address': AddressModel.fromEntity(address!).toJson(),
      };

  factory ClientModel.fromEntity(Client c) => ClientModel(
        id: c.id,
        name: c.name,
        phone: c.phone,
        email: c.email,
        cpf: c.cpf,
        address: c.address,
      );
}
