import 'dart:convert';
import 'dart:io';
import 'package:estudo_de_caso_2_trimestre/modelo/api/rotas.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/classes/user.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/local_storage_service.dart';
import 'package:http/http.dart' as http;

class Contatosapi {
  static Future<bool> salvarFotoOnline(File imagemSelecionada) async {
    String caminho = '${Rotas.rotaApi}contatos';
    final url = Uri.parse(caminho);

    try {
      User? usuario = await LocalStorageService.carregarUsuario();
      if (usuario == null) {
        print('Erro em carregar Usuario');
        return false;
      }

      var request = http.MultipartRequest('POST', url);
      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer ${usuario.token}';
      request.files.add(
        await http.MultipartFile.fromPath('imagem', imagemSelecionada.path),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final dadosRetornados = jsonDecode(response.body);
        print('Sucesso: ${dadosRetornados['contato']}');
        return true;
      } else {
        print('Erro (${response.statusCode}): ${response.body}');
        return false;
      }
    } catch (e) {
      print('Falha na conexão: $e');
      return false;
    }
  }
}
