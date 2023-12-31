import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lista_contatos/pages/detalhes_contatos.dart';
import '../http/http_client.dart';
import '../repositories/contatos_repository.dart';
import '../store/contatos_store.dart';

class EditarContato extends StatefulWidget {
  final String id;

  const EditarContato({super.key, required this.id});

  @override
  State<EditarContato> createState() => _EditarContatoState();
}

class _EditarContatoState extends State<EditarContato> {
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

  pick(ImageSource source) async {
    XFile? selectedPhoto = await imagePicker.pickImage(source: source);

    if (selectedPhoto != null) {
      String path =
          (await path_provider.getApplicationDocumentsDirectory()).path;
      String nameFoto = basename(selectedPhoto.path);
      await selectedPhoto.saveTo("$path/$nameFoto");

      await GallerySaver.saveImage(selectedPhoto.path);

      setState(() {
        photo = selectedPhoto;
      });
    }
  }

  final ContatoStore store = ContatoStore(
    repository: ContatosRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getById(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar contato'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalhesContatos(id: widget.id)));
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              store.state.value?.contatos[0].pathFoto = photo?.path;
              final updatedContatoData = {
                'Nome': nomeController.text,
                'Sobrenome': sobrenomeController.text,
                'Telefones': {
                  'Celular': telefoneCelularController.text,
                  'Trabalho': telefoneTrabalhoController.text,
                },
                'Email': emailController.text,
                'Site': siteController.text,
                'PathFoto': store.state.value?.contatos[0].pathFoto,
              };
              store.updateContato(
                  id: widget.id, novoContatoData: updatedContatoData);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetalhesContatos(id: widget.id)));
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
        child: Center(
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
                }

                if (store.erro.value.isNotEmpty || store.state.value == null) {
                  return const Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Não foi possível carregar as informações do contato',
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  );
                } else {
                  final contato = store.state.value!.contatos;
                  nomeController.text = contato[0].nome.toString();
                  sobrenomeController.text = contato[0].sobrenome.toString();
                  telefoneCelularController.text =
                      contato[0].telefones?.celular ?? '';
                  telefoneTrabalhoController.text =
                      contato[0].telefones?.trabalho ?? '';
                  emailController.text = contato[0].email.toString();
                  siteController.text = contato[0].site.toString();
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
                                                backgroundColor:
                                                    Colors.grey[200],
                                                child: const Center(
                                                  child: Icon(
                                                    FontAwesomeIcons.images,
                                                    color: Colors.indigo,
                                                  ),
                                                ),
                                              ),
                                              title: const Text(
                                                'Galeria',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                pick(ImageSource.gallery);
                                              },
                                            ),
                                            ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey[200],
                                                child: const Center(
                                                  child: Icon(
                                                    FontAwesomeIcons.camera,
                                                    color: Colors.indigo,
                                                  ),
                                                ),
                                              ),
                                              title: const Text(
                                                'Câmera',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                pick(ImageSource.camera);
                                              },
                                            ),
                                            ListTile(
                                              leading: CircleAvatar(
                                                backgroundColor:
                                                    Colors.grey[200],
                                                child: const Center(
                                                  child: Icon(
                                                    FontAwesomeIcons.trashAlt,
                                                    color: Colors.indigo,
                                                  ),
                                                ),
                                              ),
                                              title: const Text(
                                                'Remover',
                                                style: TextStyle(fontSize: 15),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                setState(() {
                                                  photo = null;
                                                  contato[0].pathFoto = null;
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
                                      : (contato[0].pathFoto != null &&
                                              contato[0].pathFoto!.isNotEmpty
                                          ? File(contato[0].pathFoto!)
                                                  .existsSync()
                                              ? FileImage(
                                                  File(contato[0].pathFoto!))
                                              : null
                                          : null),
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
                                decoration: const InputDecoration(
                                    labelText: 'Sobrenome'),
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
                                decoration: const InputDecoration(
                                    labelText: 'Trabalho'),
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
      ),
    );
  }
}
