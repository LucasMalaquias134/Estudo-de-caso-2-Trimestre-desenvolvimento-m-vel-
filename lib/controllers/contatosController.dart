import 'package:estudo_de_caso_2_trimestre/modelo/classes/contatos.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

class Contatoscontroller {
  // GABRIEL LEIAAAAAAAAA : Este é um metodo de armazernar imagem que eu desenvolvi no TCC,
  // Para voce usar ele, basta colocar a URL que foi retornada da API dos Contatos, e ela retornara uma string que é
  // o caminho da foto baixada no aplicativo entendeu? Exemplo :
  // API da : 'Url/google.com/fotos', coloque a url nesse metodo e sera retornado uma string "celularGabriel/files/fotos"
  // Crie a API de contatos no lib/modelo/api
  static Future<String?> baixarESalvarImagem(String? urlImagem) async {
    if (urlImagem != null && urlImagem.trim().isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(urlImagem));
        if (response.statusCode != 200) {
          return null;
        }
        final appDir = await getApplicationDocumentsDirectory();
        String nomeArquivo = path.basename(urlImagem);
        File arquivoLocal = File('${appDir.path}/$nomeArquivo');
        await arquivoLocal.writeAsBytes(response.bodyBytes);
        return arquivoLocal.path;
      } catch (e) {
        print("Erro aqui oooo: $e");
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<int> criarContato(
    String nome,
    String sobreNome,
    String empresa,
    String numero,
    String desc,
    String? imagem,
    bool efavorito,
  ) async {
    List<Contatos> listaContatos = await LocalStorageService.carregarContatos();

    bool jaExiste = listaContatos.any((element) => element.telefone == numero);

    if (jaExiste == true) {
      return 199;
    }

    try {
      Contatos contato = Contatos(
        id: DateTime.now().millisecondsSinceEpoch,
        nome: nome,
        telefone: numero,
        urlImage: imagem,
        descricao: desc,
        empresa: empresa,
        sobreNome: sobreNome,
        eFavorito: efavorito,
      );
      listaContatos.add(contato);
      await LocalStorageService.salvarContatos(listaContatos);
    } catch (e) {
      return 198;
    }

    return 200;
  }

  static Future<List<Contatos>> listarContatos(
    String? recurso,
    bool favorito,
    bool ordem,
  ) async {
    List<Contatos> listaContatos = await LocalStorageService.carregarContatos();

    if (favorito) {
      listaContatos = listaContatos
          .where((element) => element.eFavorito == true)
          .toList();
    }

    if (recurso != null && recurso.trim().isNotEmpty) {
      listaContatos = listaContatos
          .where(
            (element) =>
                element.nome.toLowerCase().contains(recurso.toLowerCase()),
          )
          .toList();
    }

    //Ordena Alfabeticamente ou ao Contrario
    listaContatos.sort(
      (a, b) => ordem ? a.nome.compareTo(b.nome) : b.nome.compareTo(a.nome),
    );

    return listaContatos;
  }

  static Future<int> editarContato(
    int id,
    String? nome,
    String? sobreNome,
    String? empresa,
    String? telefone,
    String? desc,
    bool? efavorito,
    String? urlImage,
  ) async {
    List<Contatos> listaContatos = await LocalStorageService.carregarContatos();

    int index = listaContatos.indexWhere((element) => element.id == id);

    if (index != -1) {
      Contatos contato = listaContatos[index];

      if (nome != null && nome.trim().isNotEmpty) {
        contato.nome = nome;
      }
      if (sobreNome != null && sobreNome.trim().isNotEmpty) {
        contato.sobreNome = sobreNome;
      }
      if (empresa != null && empresa.trim().isNotEmpty) {
        contato.empresa = empresa;
      }
      if (telefone != null && telefone.trim().isNotEmpty) {
        bool eOmesmo = (contato.telefone == telefone) ? true : false;

        if (eOmesmo == false) {
          bool jaExiste = listaContatos.any(
            (element) => element.telefone == telefone,
          );

          if (jaExiste == true) {
            return 199;
          }

          contato.telefone = telefone;
        }
      }
      if (desc != null && desc.trim().isNotEmpty) {
        contato.descricao = desc;
      }
      if (efavorito != null) {
        contato.eFavorito = efavorito;
      }
      contato.urlImage = urlImage;

      listaContatos[index] = contato;

      await LocalStorageService.salvarContatos(listaContatos);
    } else {
      return 198;
    }

    return 200;
  }

  static Future<void> deletarContatos(List<Contatos> contatos) async {
    List<Contatos> listaContatos = await LocalStorageService.carregarContatos();

    listaContatos.removeWhere(
      (item) => contatos.any((contato) => contato.id == item.id),
    );

    await LocalStorageService.salvarContatos(listaContatos);
  }
}
