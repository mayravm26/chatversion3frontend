class User {
  final String id;
  final String name;
  final String email;
  final bool online;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.online,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['nombre'],
      email: json['email'],
      online: json['online'],
    );
  }
}
