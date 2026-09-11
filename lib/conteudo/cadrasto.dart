import 'package:estudo_de_caso_2_trimestre/conteudo/login.dart';
import 'package:estudo_de_caso_2_trimestre/conteudo/telaPrincipal.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/api/usersApi.dart';
import 'package:estudo_de_caso_2_trimestre/splash/splash2.dart';
import 'package:estudo_de_caso_2_trimestre/widgetsPersonalizados/widgetsDeAjudaVersao1.dart';
import 'package:flutter/material.dart';

class Cadrasto extends StatefulWidget {
  const Cadrasto({super.key});

  @override
  State<Cadrasto> createState() => _CadrastoState();
}

class _CadrastoState extends State<Cadrasto> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController nomeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    nomeController.dispose();
    super.dispose();
  }

  void barraDeSucesso(String texto) {
    SnackBar minhaSnack = SnackBar(
      content: Text(texto),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 6),
      showCloseIcon: true,
    );
    ScaffoldMessenger.of(context).showSnackBar(minhaSnack);
  }

  void barraDeFracasso(String texto) {
    SnackBar minhaSnack = SnackBar(
      content: Text(texto),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 6),
      showCloseIcon: true,
    );
    ScaffoldMessenger.of(context).showSnackBar(minhaSnack);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.phone,
                color: Colors.indigoAccent,
                size: 150,
                shadows: [Shadow(blurRadius: 10, color: Colors.indigo)],
              ),
              Text(
                'Cradasto de Usuario Novo',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight(500),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    TextfieldPesquisar(
                      placeHolder: 'Seu nome',
                      controller: nomeController,
                      validador: (p0) {
                        if (p0 == null || p0.trim().isEmpty) {
                          return 'Por favor, insira o seu nome.';
                        }

                        if (p0.length < 3) {
                          return 'Por favor, insira um nome maior que 2 caracteres!';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextfieldPesquisar(
                      placeHolder: 'Seu email',
                      controller: emailController,
                      validador: (p0) {
                        if (p0 == null || p0.trim().isEmpty) {
                          return 'Por favor, insira o seu e-mail.';
                        }

                        if (p0.length < 3) {
                          return 'Por favor, insira um e-mail valido!.';
                        }

                        if (!(p0.contains('@'))) {
                          return 'Por favor, insira um e-mail valido!';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextfieldPesquisar(
                      placeHolder: 'Sua senha',
                      controller: senhaController,
                      validador: (p0) {
                        if (p0 == null || p0.trim().isEmpty) {
                          return 'Por favor, insira o sua senha.';
                        }

                        if (p0.length < 6) {
                          return 'Por favor, insira uma senha maior que 5 digitos!';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          int usuario = await Usersapi.registerUser(
                            nomeController.text,
                            emailController.text,
                            senhaController.text,
                          );

                          if (usuario == 201) {
                            barraDeSucesso('Login realizado Com Sucesso!');
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Splash2(3, Telaprincipal()),
                              ),
                            );
                          } else {
                            barraDeFracasso('Senha ou Email incorretos!');
                          }
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Cadastrar-se",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Future(() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ), //passar o usuario,
                    );
                  });
                },
                child: Text(
                  "Já tenho conta",
                  style: TextStyle(color: Colors.indigoAccent, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
