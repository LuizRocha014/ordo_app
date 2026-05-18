import '../../domain/entities/address.dart';

class AddressModel extends Address {
  const AddressModel({
    required super.zip,
    required super.street,
    required super.number,
    super.complement,
    required super.neighborhood,
    required super.city,
    required super.state,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        zip: json['zip'] as String,
        street: json['street'] as String,
        number: json['number'] as String,
        complement: json['complement'] as String?,
        neighborhood: json['neighborhood'] as String,
        city: json['city'] as String,
        state: json['state'] as String,
      );

  Map<String, dynamic> toJson() => {
        'zip': zip,
        'street': street,
        'number': number,
        if (complement != null) 'complement': complement,
        'neighborhood': neighborhood,
        'city': city,
        'state': state,
      };

  factory AddressModel.fromEntity(Address a) => AddressModel(
        zip: a.zip,
        street: a.street,
        number: a.number,
        complement: a.complement,
        neighborhood: a.neighborhood,
        city: a.city,
        state: a.state,
      );
}
