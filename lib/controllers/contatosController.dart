import 'package:estudo_de_caso_2_trimestre/modelo/classes/contatos.dart';
import 'package:estudo_de_caso_2_trimestre/modelo/local_storage_service.dart';

class Contatoscontroller {
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
