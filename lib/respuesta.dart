class Respuesta {
  final int id;
  final String respuesta;
  final bool esCorrecta;
  final int pregunta;

  Respuesta({
    required this.id,
    required this.respuesta,
    required this.esCorrecta,
    required this.pregunta,
  });

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      id: json['id'],
      respuesta: json['respuesta'],
      esCorrecta: json['esCorrecta'],
      pregunta: json['pregunta'],
    );
  }

  @override
  String toString() {
    return 'Respuesta: {correcta: $esCorrecta, pregunta: $pregunta}';
  }
}
