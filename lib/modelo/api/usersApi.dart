import 'dart:convert';
import 'package:estudo_de_caso_2_trimestre/modelo/api/rotas.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/classes/user.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/local_storage_service.dart';
import 'package:http/http.dart' as http;

class Usersapi {
  static Future<int> registerUser(
    String nome,
    String email,
    String senha,
  ) async {
    String caminho = '${Rotas.rotaApi}register';
    final url = Uri.parse(caminho);

    final dadosEnviar = {'name': nome, 'email': email, 'password': senha};

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(dadosEnviar),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);

      User usuario = User(
        id: responseData['user']['id'],
        name: responseData['user']['name'],
        email: responseData['user']['email'],
        token: responseData['access_token'],
      );

      await LocalStorageService.salvarUsuario(usuario);
      return 201;
    } else {
      print('Deu erro: ${response.body}');
      return response.statusCode;
    }
  }

  static Future<int> login(String email, String senha) async {
    String caminho = '${Rotas.rotaApi}login';
    final url = Uri.parse(caminho);

    try {
      final dadosEnviar = {'email': email, 'password': senha};

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dadosEnviar),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData);

        User usuario = User(
          id: responseData['user']['id'],
          name: responseData['user']['name'],
          email: responseData['user']['email'],
          token: responseData['token'],
        );

        await LocalStorageService.salvarUsuario(usuario);
        return 200;
      } else {
        print('Erro no login: ${jsonDecode(response.body)['message']}');
        return 500;
      }
    } catch (e) {
      print('Deu erro: $e');
      return 500;
    }
  }

  static Future<int> logoutAPI(User usuario) async {
    String caminho = '${Rotas.rotaApi}logout';
    final url = Uri.parse(caminho);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${usuario.token}',
      },
    );

    if (response.statusCode == 204) {
      await LocalStorageService.deslogarUsuario();

      return 204;
    } else {
      print(
        'Erro no servidor: ${response.body} (Código: ${response.statusCode})',
      );
      return response.statusCode;
    }
  }

  static Future<bool> verificaSessao(String token) async {
    String caminho = '${Rotas.rotaApi}me';
    final url = Uri.parse(caminho);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print(
        'Erro no servidor: ${response.body} (Código: ${response.statusCode})',
      );
      return false;
    }
  }
}
