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
  // Setters
  set setNombre(String nombre) {
    this.nombre = nombre;
  }

  set setApellidos(String apellidos) {
    this.apellidos = apellidos;
  }

  set setEmail(String email) {
    this.email = email;
  }

  set setPassword(String password) {
    this.password = password;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombre: json['nombre'],
      apellidos: json['apellido'],
      email: json['correo'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'correo': email,
    };
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
