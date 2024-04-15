class User {
  final int id;
  String nombre;
  String apellidos;
  String email;
  String password;

  User({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellido'],
      email: json['correo'],
      password: json['password'],
    );
  }

  static User clone(User currentUser) {
    return User(
      id: currentUser.id,
      nombre: currentUser.nombre,
      apellidos: currentUser.apellidos,
      email: currentUser.email,
      password: currentUser.password,
    );
  }
}
