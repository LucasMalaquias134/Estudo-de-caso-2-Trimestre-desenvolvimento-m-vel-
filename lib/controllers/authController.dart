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
      bool usuarioAtivoWeb = await Usersapi.verificaSessao(
        usuarioAtivoMobile.token!,
      );

      if (usuarioAtivoWeb == true) {
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

  static Future<bool> logout(User usuario) async {
    try {
      int resultadoOnline = await Usersapi.logoutAPI(usuario);
      if (resultadoOnline == 204) {
        await LocalStorageService.limparTudo();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
