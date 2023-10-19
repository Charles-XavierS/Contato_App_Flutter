import 'dart:convert';

import 'package:lista_contatos/http/http_client.dart';
import 'package:lista_contatos/models/contatos_model.dart';

abstract class IContatosRepository {
  Future<ContatosModel> getContatos({required Map<String, String> headers});
  Future<ContatosModel> getById({
    required String id,
    required Map<String, String> headers,
  });
  Future<void> updateContato({
    required String id,
    required Map<String, String> headers,
    required Map<String, dynamic> contatoData,
  });
  Future<void> createContato({
    required Map<String, String> headers,
    required Map<String, dynamic> novoContatoData,
  });
  Future<void> deleteContato(
      {required String id, required Map<String, String> headers});
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

  @override
  Future<ContatosModel> getById(
      {required String id, required Map<String, String> headers}) async {
    final response = await client.get(
      url: 'https://parseapi.back4app.com/classes/Contacts/$id',
      headers: headers,
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final detalhes = ContatosModel.fromJson(body);
      return detalhes;
    } else {
      throw Exception('Falha ao carregar os detalhes');
    }
  }

  @override
  Future<void> updateContato({
    required String id,
    required Map<String, String> headers,
    required Map<String, dynamic> contatoData,
  }) async {
    final response = await client.put(
      url: 'https://parseapi.back4app.com/classes/Contacts/$id',
      headers: headers,
      body: jsonEncode(contatoData),
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao atualizar o contato');
    }
  }

  @override
  Future<void> createContato({
    required Map<String, String> headers,
    required Map<String, dynamic> novoContatoData,
  }) async {
    final response = await client.post(
      url: 'https://parseapi.back4app.com/classes/Contacts',
      headers: headers,
      body: jsonEncode(novoContatoData),
    );

    if (response.statusCode != 201) {
      throw Exception('Falha ao criar o novo contato');
    }
  }

  @override
  Future<void> deleteContato(
      {required String id, required Map<String, String> headers}) async {
    final response = await client.delete(
      url: 'https://parseapi.back4app.com/classes/Contacts/$id',
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir o contato');
    }
  }
}
