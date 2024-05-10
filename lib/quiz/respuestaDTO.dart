class RespuestaDTO {
  String respuesta;
  bool esCorrecta;

  RespuestaDTO({
    required this.respuesta,
    required this.esCorrecta,
  });

  factory RespuestaDTO.fromJson(Map<String, dynamic> json) {
    return RespuestaDTO(
      respuesta: json['respuesta'],
      esCorrecta: json['esCorrecta'],
    );
  }

  bool get isCorrect => esCorrecta;

  set isCorrect(bool value) {
    esCorrecta = value;
  }

  @override
  String toString() {
    return 'Respuesta: {correcta: $esCorrecta, respuesta: $respuesta}';
  }

  Map<String, dynamic> toJson() => {
        'respuesta': respuesta,
        'esCorrecta': esCorrecta,
      };
}
