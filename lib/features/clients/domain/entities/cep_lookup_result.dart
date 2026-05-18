/// Resultado da consulta de CEP (ViaCEP).
///
/// O número da casa não vem nesse retorno — o usuário preenche manual
/// no formulário. Os demais campos vêm preenchidos quando o CEP é
/// válido.
class CepLookupResult {
  final String zip;
  final String street;
  final String? complement;
  final String neighborhood;
  final String city;
  final String state;

  const CepLookupResult({
    required this.zip,
    required this.street,
    this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
  });
}
