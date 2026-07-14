import 'dart:io';

import 'package:estudo_de_caso_2_trimestre/controllers/contatosController.dart';
import 'package:estudo_de_caso_2_trimestre/widgetsPersonalizados/widgetsDeAjudaVersao1.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Telacriarcontato extends StatefulWidget {
  const Telacriarcontato({super.key});

  @override
  State<Telacriarcontato> createState() => _TelacriarcontatoState();
}

class _TelacriarcontatoState extends State<Telacriarcontato> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController sobreNomeController = TextEditingController();
  TextEditingController empresaController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController descricaoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nomeController.dispose();
    sobreNomeController.dispose();
    empresaController.dispose();
    telefoneController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  bool favorito = false;

  File? arquivoDaImagem;

  Future<void> pickImagen() async {
    XFile? imagemSelecionada = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (imagemSelecionada != null) {
      setState(() {
        arquivoDaImagem = File(imagemSelecionada.path);
      });
    }
  }

  void barraDeSucesso() {
    SnackBar minhaSnack = SnackBar(
      content: Text('Novo contato criado com sucesso!'),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
      showCloseIcon: true,
    );
    ScaffoldMessenger.of(context).showSnackBar(minhaSnack);
  }

  void erroShowDialog(String erro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Atenção'),
          content: Text(erro),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          tooltip: 'Cancelar',
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Criar Contato', style: TextStyle(color: Colors.white)),
            Spacer(),
            (favorito == false)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        favorito = true;
                      });
                    },
                    icon: Icon(Icons.star_border, color: Colors.white),
                  )
                : IconButton.filled(
                    onPressed: () {
                      setState(() {
                        favorito = false;
                      });
                    },
                    icon: Icon(Icons.star),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.indigoAccent.withValues(
                        alpha: 0.8,
                      ),
                      foregroundColor: Colors.white,
                    ),
                  ),
            SizedBox(width: 10),
            SalvarContato(
              texto: 'Salvar',
              funcao: () async {
                if (_formKey.currentState!.validate()) {
                  int resultado = await Contatoscontroller.criarContato(
                    nomeController.text,
                    sobreNomeController.text,
                    empresaController.text,
                    telefoneController.text,
                    descricaoController.text,
                    arquivoDaImagem?.path,
                    favorito,
                  );

                  switch (resultado) {
                    case 198:
                      erroShowDialog('Algo deu errado, tente novamente!');
                      break;
                    case 199:
                      erroShowDialog('ja existe esse numero salvo!');
                      break;
                    case 200:
                      barraDeSucesso();
                      Navigator.pop(context);
                      break;
                    default:
                  }
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 30, vertical: 25),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Stack(
                    alignment: AlignmentGeometry.bottomRight,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await pickImagen();
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(
                            0xFF6C63FF,
                          ).withValues(alpha: 0.3),
                          child:
                              arquivoDaImagem == null ||
                                  arquivoDaImagem!.path.isEmpty
                              ? const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                )
                              : ClipOval(
                                  child: SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Image.file(
                                      File(arquivoDaImagem!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      if (arquivoDaImagem != null)
                        IconButton.filled(
                          onPressed: () {
                            setState(() {
                              arquivoDaImagem = null;
                            });
                          },
                          icon: Icon(Icons.delete),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red.withValues(alpha: 0.8),
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextfieldPesquisar(
                    placeHolder: 'Nome',
                    controller: nomeController,
                    placeHolder2: '',
                    validador: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, preencha este campo';
                      }
                      if (value.length < 3) {
                        return 'O nome precisa ter pelo menos 3 letras';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextfieldPesquisar(
                    placeHolder: 'Sobrenome',
                    controller: sobreNomeController,
                    placeHolder2: '',
                    validador: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }

                      if (value.trim().length < 3) {
                        return 'O sobrenome precisa ter pelo menos 3 letras';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  TextfieldPesquisar(
                    placeHolder: 'Empresa',
                    controller: empresaController,
                    placeHolder2: '',
                    validador: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return null;
                      }

                      if (value.trim().length < 3) {
                        return 'O nome da empresa precisa ter pelo menos 3 letras';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextfieldPesquisar(
                    placeHolder: 'Telefone (celular)',
                    controller: telefoneController,
                    placeHolder2: '',
                    numerico: true,
                    validador: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Por favor, preencha este campo';
                      }
                      // Aceita formatos como: 11999999999, +5511999999999, 1199999-9999, +55 (11) 99999-9999
                      final RegExp regexCelular = RegExp(
                        r'^\+?(?:\d{2})?\s?\(?\d{2}\)?\s?9\d{4}-?\d{4}$',
                      );

                      if (!regexCelular.hasMatch(value.trim())) {
                        return 'O número de telefone precisa ser um número válido!';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  TextfieldPesquisar(
                    placeHolder: 'Observações',
                    controller: descricaoController,
                    placeHolder2: '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
