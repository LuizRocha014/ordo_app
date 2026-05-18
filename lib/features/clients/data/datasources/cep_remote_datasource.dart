import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/cep_lookup_result.dart';

class CepInvalidException implements Exception {
  final String message;
  const CepInvalidException(this.message);
}

class CepNotFoundException implements Exception {
  const CepNotFoundException();
}

abstract class CepRemoteDataSource {
  Future<CepLookupResult> lookup(String cep);
}

/// Implementação que bate em ViaCEP (https://viacep.com.br).
class ViaCepDataSource implements CepRemoteDataSource {
  final http.Client _http;

  ViaCepDataSource({http.Client? client}) : _http = client ?? http.Client();

  @override
  Future<CepLookupResult> lookup(String cep) async {
    final digits = cep.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 8) {
      throw const CepInvalidException('CEP precisa ter 8 dígitos.');
    }

    final uri = Uri.parse('https://viacep.com.br/ws/$digits/json/');
    final response = await _http.get(uri);
    if (response.statusCode != 200) {
      throw const CepNotFoundException();
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (body['erro'] == true) {
      throw const CepNotFoundException();
    }

    return CepLookupResult(
      zip: digits,
      street: (body['logradouro'] as String?) ?? '',
      complement: body['complemento'] as String?,
      neighborhood: (body['bairro'] as String?) ?? '',
      city: (body['localidade'] as String?) ?? '',
      state: (body['uf'] as String?) ?? '',
    );
  }
}
