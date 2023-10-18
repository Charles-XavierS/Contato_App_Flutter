import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/material.dart';
import 'package:lista_contatos/http/http_client.dart';
import 'package:lista_contatos/repositories/contatos_repository.dart';
import 'package:lista_contatos/store/contatos_store.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

Color getRandomColor() {
  final random = Random();
  final alfa = random.nextInt(255);
  final red = random.nextInt(256);
  final green = random.nextInt(256);
  final blue = random.nextInt(256);
  return Color.fromARGB(alfa, red, green, blue);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lista de Contatos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Contatos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ContatoStore store = ContatoStore(
    repository: ContatosRepository(
      client: HttpClient(),
    ),
  );

  @override
  void initState() {
    super.initState();
    store.getContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.frown,
                      color: Colors.indigoAccent, size: 40),
                  Padding(padding: EdgeInsets.symmetric(vertical: 15)),
                  Text(
                    textAlign: TextAlign.center,
                    'Não foi possível carregar a lista de contatos',
                    style: TextStyle(
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            );
          }

          if (store.state.value!.contatos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum contato salvo',
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: store.state.value!.contatos.length,
              itemBuilder: (context, index) {
                final sortedContatos = store.state.value!.contatos;
                sortedContatos.sort((a, b) {
                  return (a.nome ?? '').compareTo(b.nome ?? '');
                });
                final item = sortedContatos[index];
                final cores = item.cor;
                return GestureDetector(
                  onTap: () {},
                  child: Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      shadowColor: Colors.black,
                      child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                    cores![0], cores[1], cores[2], cores[3]),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Text(
                                  item.nome?.isNotEmpty == true
                                      ? item.nome![0]
                                      : '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              "${item.nome} ${item.sobrenome}",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              "${item.telefones?.celular}",
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                          ))),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }
}
