import 'dart:convert';

class Contatos {
  final int id;
  String nome;
  String? sobreNome;
  String? empresa;
  String telefone;
  String? descricao;
  String? urlImage;
  bool? eFavorito;

  Contatos({
    required this.id,
    required this.nome,
    required this.telefone,
    required this.urlImage,
    required this.descricao,
    required this.empresa,
    required this.sobreNome,
    required this.eFavorito,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'telefone': telefone,
      'descricao': descricao,
      'empresa': empresa,
      'urlImage': urlImage,
      'sobreNome': sobreNome,
      'eFavorito': eFavorito,
    };
  }

  factory Contatos.fromMap(Map<String, dynamic> map) {
    return Contatos(
      id: map['id'] ?? 0,
      nome: map['nome'] ?? '',
      telefone: map['telefone'] ?? '',
      descricao: map['descricao'] ?? null,
      sobreNome: map['sobreNome'] ?? null,
      empresa: map['empresa'] ?? null,
      urlImage: map['urlImage'] ?? '',
      eFavorito: map['eFavorito'] ?? false,
    );
  }

  static String encode(List<Contatos> contatos) => json.encode(
    contatos.map<Map<String, dynamic>>((p) => p.toMap()).toList(),
  );

  static List<Contatos> decode(String exerciciosJson) =>
      (json.decode(exerciciosJson) as List<dynamic>)
          .map<Contatos>((item) => Contatos.fromMap(item))
          .toList();
}
