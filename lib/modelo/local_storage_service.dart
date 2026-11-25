import 'dart:convert';

import 'package:estudo_de_caso_2_trimestre/modelo/classes/contatos.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/classes/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String LISTA_USERS = 'lista_users';
  static const String LISTA_CONTATOS = 'lista_contatos';

  //====================================Recurso Contatos
  static Future<void> salvarContatos(List<Contatos> lista) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = Contatos.encode(lista);
    await prefs.setString(LISTA_CONTATOS, encodedData);
  }

  static Future<List<Contatos>> carregarContatos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? ContatosJson = prefs.getString(LISTA_CONTATOS);

    if (ContatosJson == null) return [];

    return Contatos.decode(ContatosJson);
  }

  //====================================Recurso Usuario

  static Future<void> salvarUsuario(User usuario) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(usuario.toMap());
    await prefs.setString(LISTA_USERS, encodedData);
  }

  static Future<User?> carregarUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usuariosJson = prefs.getString(LISTA_USERS);

    if (usuariosJson == null) return null;

    return User.fromMap(json.decode(usuariosJson));
  }

  static Future<void> deslogarUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(LISTA_USERS);
  }

  //====================================Recurso Apagar

  static Future<void> limparTudo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
