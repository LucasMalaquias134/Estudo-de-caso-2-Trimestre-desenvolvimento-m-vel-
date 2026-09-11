import 'package:estudo_de_caso_2_trimestre/conteudo/login.dart';
import 'package:estudo_de_caso_2_trimestre/conteudo/telaPrincipal.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/api/usersApi.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/classes/user.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/local_storage_service.dart';
import 'package:flutter/material.dart';

class Authcontroller {
  static Future<void> verificaSessao(BuildContext context) async {
    User? usuarioAtivoMobile = await LocalStorageService.carregarUsuario();

    if (usuarioAtivoMobile == null) {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      });
    } else {
      int usuarioAtivoWeb = await Usersapi.verificaSessao(
        usuarioAtivoMobile.token!,
      );

      if (usuarioAtivoWeb == 200) {
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Telaprincipal(),
            ), //passar o usuario,
          );
        });
      } else {
        await LocalStorageService.deslogarUsuario();
        Future.delayed(Duration(seconds: 3), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login()),
          );
        });
      }
    }
  }
}
