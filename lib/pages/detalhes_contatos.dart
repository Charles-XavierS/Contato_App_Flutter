import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:lista_contatos/main.dart';

import '../http/http_client.dart';
import '../repositories/contatos_repository.dart';
import '../store/contatos_store.dart';
import 'editar_contato.dart';

class DetalhesContatos extends StatefulWidget {
  final String id;

  const DetalhesContatos({super.key, required this.id});

  @override
  State<DetalhesContatos> createState() => _DetalhesContatosState();
}

class _DetalhesContatosState extends State<DetalhesContatos> {
  final ContatoStore store = ContatoStore(
    repository: ContatosRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getById(id: widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Detalhes do contato'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Cadastro'),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditarContato(id: widget.id)));
              },
              icon: const Icon(
                FontAwesomeIcons.edit,
                color: Colors.white,
              ),
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    child: ListTile(
                      title: const Text(
                        "Excluir",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        store.deleteContato(id: widget.id);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const MyHomePage(title: 'Cadastro'),
                          ),
                        );
                      },
                    ),
                  ),
                ];
              },
            ),
          ],
          backgroundColor: Colors.indigoAccent),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          store.isLoading,
          store.erro,
          store.state,
        ]),
        builder: (context, child) {
          if (store.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (store.erro.value.isNotEmpty) {
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
          }

          if (store.state.value == null) {
            return const Center(
              child: Text(
                textAlign: TextAlign.center,
                'Contato não encontrado',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            final contato = store.state.value!.contatos;
            final cores = contato[0].cor;
            return Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Color.fromARGB(
                                cores![0], cores[1], cores[2], cores[3]),
                            foregroundColor: Colors.black,
                            child: contato[0].pathFoto == ''
                                ? Text(
                                    contato[0].nome![0],
                                    style: const TextStyle(
                                      fontSize: 80,
                                    ),
                                  )
                                : const Icon(FontAwesomeIcons.user),
                          )),
                      Text(
                        '${contato[0].nome}',
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w600),
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
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Visibility(
                        visible: contato[0].telefones?.celular != '',
                        child: ListTile(
                            leading: const Icon(Icons.phone),
                            title: Text('${contato[0].telefones?.celular}')),
                      ),
                      Visibility(
                        visible: contato[0].telefones?.trabalho != '',
                        child: ListTile(
                            leading: const SizedBox(),
                            title: Text('${contato[0].telefones?.trabalho}')),
                      ),
                      Visibility(
                        visible: contato[0].email != '',
                        child: ListTile(
                          leading: const Icon(Icons.mail),
                          title: Text('${contato[0].email}'),
                        ),
                      ),
                      Visibility(
                        visible: contato[0].site != '',
                        child: ListTile(
                          leading: const Icon(Icons.link),
                          title: Text('${contato[0].site}'),
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
    );
  }
}
