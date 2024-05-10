class Respuesta {
  int id;
  String respuesta;
  bool esCorrecta;
  int pregunta;

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

  bool get isCorrect => esCorrecta;

  set isCorrect(bool value) {
    esCorrecta = value;
  }

  @override
  String toString() {
    return 'Respuesta: {correcta: $esCorrecta, pregunta: $pregunta}';
  }
}
