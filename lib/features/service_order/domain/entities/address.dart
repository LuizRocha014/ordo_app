/// Endereço completo de um cliente.
///
/// Modelado como value-object — todos os campos são finais e o objeto
/// é imutável. `complement` é opcional; o resto é obrigatório quando
/// o usuário decide preencher endereço.
class Address {
  final String zip;
  final String street;
  final String number;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;

  const Address({
    required this.zip,
    required this.street,
    required this.number,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });

  /// Representação compacta — `Rua X, 123 (apt 4) · Bairro · Cidade/UF · CEP 00000-000`.
  String get oneLine {
    final compl =
        (complement != null && complement!.isNotEmpty) ? ' ($complement)' : '';
    final zipFmt = zip.length == 8
        ? '${zip.substring(0, 5)}-${zip.substring(5)}'
        : zip;
    return '$street, $number$compl · $neighborhood · $city/$state · CEP $zipFmt';
  }
}
