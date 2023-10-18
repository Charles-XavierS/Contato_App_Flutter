import 'package:flutter/material.dart';
import 'package:lista_contatos/models/contatos_model.dart';
import 'package:lista_contatos/repositories/contatos_repository.dart';

class ContatoStore {
  final IContatosRepository repository;

  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  final ValueNotifier<ContatosModel?> state =
      ValueNotifier<ContatosModel?>(null);

  final ValueNotifier<String> erro = ValueNotifier<String>('');

  ContatoStore({required this.repository});

  Future getContatos() async {
    isLoading.value = true;

    try {
      final headers = {
        'X-Parse-Application-Id': 'IYIajHqy8Bc70bk4INzBdjs4JUEbMx9laUJbj5ms',
        'X-Parse-REST-API-Key': 'VUUYNUVP7L64hrhBFuOdQ6YOCeya3us3UFKxQdiW',
      };

      final result = await repository.getContatos(headers: headers);

      state.value = result;
    } catch (e) {
      erro.value = e.toString();
    }

    isLoading.value = false;
  }
}
