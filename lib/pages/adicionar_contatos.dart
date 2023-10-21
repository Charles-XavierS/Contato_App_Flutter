import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:lista_contatos/main.dart';
import '../http/http_client.dart';
import '../repositories/contatos_repository.dart';
import '../store/contatos_store.dart';

class AdicionarContato extends StatefulWidget {
  const AdicionarContato({Key? key});

  @override
  State<AdicionarContato> createState() => _AdicionarContatoState();
}

getRandomColor() {
  final random = Random();
  final array = [];
  final alfa = random.nextInt(255);
  final red = random.nextInt(256);
  final green = random.nextInt(256);
  final blue = random.nextInt(256);
  array.add(alfa);
  array.add(red);
  array.add(green);
  array.add(blue);
  return array;
}

class _AdicionarContatoState extends State<AdicionarContato> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController sobrenomeController = TextEditingController();
  final TextEditingController telefoneCelularController =
      TextEditingController();
  final TextEditingController telefoneTrabalhoController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController siteController = TextEditingController();

  final imagePicker = ImagePicker();
  XFile? photo;

  final ContatoStore store = ContatoStore(
    repository: ContatosRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickImageFromGallery() async {
    final selectedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      setState(() {
        photo = selectedImage;
      });
    }
  }

  Future<void> captureImage() async {
    final capturedImage =
        await imagePicker.pickImage(source: ImageSource.camera);

    if (capturedImage != null) {
      setState(() {
        photo = capturedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar contato'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Cadastro')),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              final createContatoData = {
                'Nome': nomeController.text,
                'Sobrenome': sobrenomeController.text,
                'Telefones': {
                  'Celular': telefoneCelularController.text,
                  'Trabalho': telefoneTrabalhoController.text,
                },
                'Email': emailController.text,
                'Site': siteController.text,
                'PathFoto': photo?.path ?? '',
                'Cor': getRandomColor(),
              };
              store.createContato(novoContatoData: createContatoData);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Cadastro')),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.indigo,
              ),
              child: const Text(
                'Salvar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
        backgroundColor: Colors.indigoAccent,
      ),
      body: WillPopScope(
        onWillPop: () async {
          FocusManager.instance.primaryFocus?.unfocus();
          return true;
        },
        child: SingleChildScrollView(
          child: AnimatedBuilder(
            animation: Listenable.merge([
              store.isLoading,
              store.erro,
              store.state,
            ]),
            builder: (context, child) {
              if (store.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: GestureDetector(
                              onTap: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (_) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.image,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            title: const Text(
                                              'Escolher da Galeria',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              pickImageFromGallery();
                                            },
                                          ),
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            title: const Text(
                                              'Tirar Foto',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              captureImage();
                                            },
                                          ),
                                          ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Colors.grey[200],
                                              child: const Center(
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.indigo,
                                                ),
                                              ),
                                            ),
                                            title: const Text(
                                              'Remover Foto',
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                photo = null;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                radius: 100,
                                backgroundImage: photo != null
                                    ? FileImage(File(photo!.path))
                                    : null,
                                backgroundColor: Colors.grey,
                                foregroundColor: Colors.black,
                                child: const Icon(
                                  Icons.add_a_photo,
                                  size: 80,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Card(
                      margin: const EdgeInsets.all(15),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            title: TextField(
                              controller: nomeController,
                              decoration:
                                  const InputDecoration(labelText: 'Nome'),
                            ),
                          ),
                          ListTile(
                            title: TextField(
                              controller: sobrenomeController,
                              decoration:
                                  const InputDecoration(labelText: 'Sobrenome'),
                            ),
                          ),
                          ListTile(
                            title: TextField(
                              controller: telefoneCelularController,
                              decoration:
                                  const InputDecoration(labelText: 'Celular'),
                            ),
                          ),
                          ListTile(
                            title: TextField(
                              controller: telefoneTrabalhoController,
                              decoration:
                                  const InputDecoration(labelText: 'Trabalho'),
                            ),
                          ),
                          ListTile(
                            title: TextField(
                              controller: emailController,
                              decoration:
                                  const InputDecoration(labelText: 'Email'),
                            ),
                          ),
                          ListTile(
                            title: TextField(
                              controller: siteController,
                              decoration:
                                  const InputDecoration(labelText: 'Site'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
