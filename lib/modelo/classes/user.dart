import 'dart:convert';

class User {
  final int? id;
  final String name;
  final String email;
  final String? token;

  User({this.id, required this.name, required this.email, this.token});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'email': email, 'token': token};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      token: map['token'] ?? '',
    );
  }

  static String encode(List<User> usuarios) => json.encode(
    usuarios.map<Map<String, dynamic>>((p) => p.toMap()).toList(),
  );

  static List<User> decode(String usersJson) =>
      (json.decode(usersJson) as List<dynamic>)
          .map<User>((item) => User.fromMap(item))
          .toList();
}
