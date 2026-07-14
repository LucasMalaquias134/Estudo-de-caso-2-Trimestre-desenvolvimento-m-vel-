import 'package:estudo_de_caso_2_trimestre/modelo/classes/contatos.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String LISTA_CONTATOS = 'lista_contatos';

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
}
