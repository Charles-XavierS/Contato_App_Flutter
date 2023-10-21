import 'dart:async';

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

    Timer(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
  }

  Future getById({required String id}) async {
    isLoading.value = true;

    try {
      final headers = {
        'X-Parse-Application-Id': 'IYIajHqy8Bc70bk4INzBdjs4JUEbMx9laUJbj5ms',
        'X-Parse-REST-API-Key': 'VUUYNUVP7L64hrhBFuOdQ6YOCeya3us3UFKxQdiW',
      };

      final result = await repository.getById(headers: headers, id: id);

      state.value = result;
    } catch (e) {
      erro.value = e.toString();
    }

    Timer(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
  }

  Future updateContato(
      {required String id,
      required Map<String, dynamic> novoContatoData}) async {
    isLoading.value = true;

    try {
      final headers = {
        'X-Parse-Application-Id': 'IYIajHqy8Bc70bk4INzBdjs4JUEbMx9laUJbj5ms',
        'X-Parse-REST-API-Key': 'VUUYNUVP7L64hrhBFuOdQ6YOCeya3us3UFKxQdiW',
        'Content-Type': 'application/json',
      };

      novoContatoData['objectId'] = id;

      await repository.updateContato(
          headers: headers, id: id, contatoData: novoContatoData);
    } catch (e) {
      erro.value = e.toString();
    }

    Timer(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
  }

  Future createContato({required Map<String, dynamic> novoContatoData}) async {
    isLoading.value = true;

    try {
      final headers = {
        'X-Parse-Application-Id': 'IYIajHqy8Bc70bk4INzBdjs4JUEbMx9laUJbj5ms',
        'X-Parse-REST-API-Key': 'VUUYNUVP7L64hrhBFuOdQ6YOCeya3us3UFKxQdiW',
        'Content-Type': 'application/json',
      };

      await repository.createContato(
          headers: headers, novoContatoData: novoContatoData);
    } catch (e) {
      erro.value = e.toString();
    }

    Timer(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
  }

  Future deleteContato({required String id}) async {
    isLoading.value = true;

    try {
      final headers = {
        'X-Parse-Application-Id': 'IYIajHqy8Bc70bk4INzBdjs4JUEbMx9laUJbj5ms',
        'X-Parse-REST-API-Key': 'VUUYNUVP7L64hrhBFuOdQ6YOCeya3us3UFKxQdiW',
      };

      await repository.deleteContato(id: id, headers: headers);
    } catch (e) {
      erro.value = e.toString();
    }

    Timer(const Duration(milliseconds: 600), () {
      isLoading.value = false;
    });
  }
}
