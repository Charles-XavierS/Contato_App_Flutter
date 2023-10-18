import 'dart:convert';

import 'package:lista_contatos/http/http_client.dart';
import 'package:lista_contatos/models/contatos_model.dart';

abstract class IContatosRepository {
  Future<ContatosModel> getContatos({required Map<String, String> headers});
}

class ContatosRepository implements IContatosRepository {
  final IHttpClient client;

  ContatosRepository({required this.client});

  @override
  Future<ContatosModel> getContatos(
      {required Map<String, String> headers}) async {
    final response = await client.get(
      url: 'https://parseapi.back4app.com/classes/Contacts',
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final contatos = ContatosModel.fromJson(body);
      return contatos;
    } else {
      throw Exception('Falha ao carregar os contatos');
    }
  }
}
