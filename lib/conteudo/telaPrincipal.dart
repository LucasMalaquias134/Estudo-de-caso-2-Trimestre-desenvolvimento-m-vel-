import 'dart:io';
import 'dart:math' as math;

import 'package:estudo_de_caso_2_trimestre/conteudo/telaCriarContato.dart';
import 'package:estudo_de_caso_2_trimestre/conteudo/telaEditarContato.dart';
import 'package:estudo_de_caso_2_trimestre/controllers/contatosController.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/classes/contatos.dart';
import 'package:estudo_de_caso_2_trimestre/widgetsPersonalizados/widgetsDeAjudaVersao1.dart';
import 'package:flutter/material.dart';

class Telaprincipal extends StatefulWidget {
  const Telaprincipal({super.key});

  @override
  State<Telaprincipal> createState() => _TelaprincipalState();
}

class _TelaprincipalState extends State<Telaprincipal> {
  TextEditingController pesquisaController = TextEditingController();

  bool favorito = false;
  bool ordem = true;
  String? recurso = '';

  List<Contatos?> contatos = [];
  List<Contatos> selecionados = [];
  List<String> iniciasJaExistentes = [];

  Future<void> carregarDados() async {
    try {
      final dados = await Contatoscontroller.listarContatos(
        '',
        favorito,
        ordem,
      );
      setState(() {
        contatos = dados;
      });

      arrumarIniciasi(contatos);
    } catch (x) {
      print("Sem dados persistidos $x");
    }
  }

  void arrumarIniciasi(List<Contatos?> contatos) {
    iniciasJaExistentes = [];
    contatos.forEach((element) {
      if (!(iniciasJaExistentes.contains(element?.nome[0].toLowerCase()))) {
        iniciasJaExistentes.add(element!.nome[0].toLowerCase());
      }
    });
  }

  List<Contatos?> separadosProfissalmente(String letra) {
    List<Contatos?> contatosSeparados = contatos
        .where(
          (element) =>
              element!.nome[0].toLowerCase().contains(letra.toLowerCase()),
        )
        .toList();
    return contatosSeparados;
  }

  appBar() {
    return (selecionados.isEmpty)
        ? AppBar(
            backgroundColor: Colors.black,
            title: Text('Contatos', style: TextStyle(color: Colors.white)),
          )
        : AppBar(
            backgroundColor: Colors.grey.withValues(alpha: 0.5),
            leading: IconButton(
              onPressed: () {
                setState(() {
                  selecionados = [];
                });
              },
              icon: Icon(Icons.close),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selecionados.length} selecionados',
                  style: TextStyle(color: Colors.white),
                ),

                IconButton(
                  onPressed: () async {
                    await Contatoscontroller.deletarContatos(selecionados);
                    selecionados = [];
                    carregarDados();
                  },
                  icon: Icon(Icons.delete),
                ),
              ],
            ),
          );
  }

  @override
  void initState() {
    carregarDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          children: [
            TextfieldPesquisar(
              placeHolder: '',
              controller: pesquisaController,
              icone: Icons.search,
              labelFlutante: true,
              placeHolder2: 'Pesquisar contatos...',
              temRadius: true,
              radius: 100,
              backgroundCor: Colors.grey.withValues(alpha: 0.2),
              enviado: (pesquisa) async {
                List<Contatos?> contatosPesquisados =
                    await Contatoscontroller.listarContatos(
                      pesquisa,
                      favorito,
                      ordem,
                    );
                setState(() {
                  recurso = pesquisa;
                  contatos = contatosPesquisados;
                  arrumarIniciasi(contatosPesquisados);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    List<Contatos?> favoritados =
                        await Contatoscontroller.listarContatos(
                          recurso,
                          !favorito,
                          ordem,
                        );

                    setState(() {
                      favorito = !favorito;
                      contatos = favoritados;
                      arrumarIniciasi(favoritados);
                    });
                  },
                  icon: Icon(
                    !favorito ? Icons.star_border : Icons.star,
                    color: Colors.white,
                  ),
                ),

                IconButton(
                  onPressed: () async {
                    ordem = !ordem;

                    List<Contatos?> contatosOrdenados =
                        await Contatoscontroller.listarContatos(
                          recurso,
                          favorito,
                          ordem,
                        );
                    setState(() {
                      contatos = contatosOrdenados;
                      arrumarIniciasi(contatosOrdenados);
                    });
                  },
                  icon: ordem
                      ? Icon((Icons.filter_list), color: Colors.white)
                      : Transform.rotate(
                          angle: math.pi,
                          child: Icon(Icons.filter_list, color: Colors.white),
                        ),
                ),
              ],
            ),
            if (contatos.isEmpty)
              Text(
                'Nenhum Contato Encontrado.',
                style: TextStyle(color: Colors.white),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: iniciasJaExistentes.length,
                  itemBuilder: (context, index) {
                    final inicial = iniciasJaExistentes[index];

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(left: 5),
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            inicial.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: separadosProfissalmente(inicial).length,
                            itemBuilder: (context, index) {
                              final contato = separadosProfissalmente(
                                inicial,
                              )[index];

                              return Card(
                                clipBehavior: Clip.antiAlias,
                                color: Colors.grey.withValues(alpha: 0.2),
                                child: ListTile(
                                  title: Text(
                                    contato!.sobreNome == null
                                        ? contato.nome
                                        : '${contato.nome} ${contato.sobreNome}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Color(
                                      0xFF6C63FF,
                                    ).withValues(alpha: 0.3),
                                    child:
                                     (selecionados.contains(contato)) ?
                                      Icon(Icons.check,color: Colors.white,):
                                        contato.urlImage != null &&
                                            contato.urlImage!.isNotEmpty
                                        ? ClipOval(
                                            child: SizedBox(
                                              width: 120,
                                              height: 120,
                                              child: Image.file(
                                                File(contato.urlImage!),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                        : Text(
                                            contato.nome[0],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                  trailing: Text(
                                    contato.telefone,
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    (selecionados.isEmpty)
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Telaeditarcontato(
                                                    contato: contato,
                                                  ),
                                            ),
                                          ).then((_) {
                                            carregarDados();
                                          })
                                        : setState(() {
                                            (selecionados.contains(contato))
                                                ? selecionados.remove(contato)
                                                : selecionados.add(contato);
                                          });
                                  },
                                  selected: selecionados.contains(contato),
                                  selectedTileColor: Colors.grey.withValues(
                                    alpha: 0.5,
                                  ),

                                  onLongPress: () {
                                    setState(() {
                                      (selecionados.contains(contato))
                                          ? selecionados.remove(contato)
                                          : selecionados.add(contato);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Telacriarcontato()),
          ).then((_) {
            carregarDados();
          });
        },
        backgroundColor: Colors.indigo,
        tooltip: 'Criar contato',
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
