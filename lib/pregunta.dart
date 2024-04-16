import 'respuesta.dart';

class Pregunta {
  final int id;
  final String pregunta;
  final String tematica;
  final List<Respuesta> respuestas;

  Pregunta({
    required this.id,
    required this.pregunta,
    required this.tematica,
    required this.respuestas,
  });

  esCorrecta(int respuestaSeleccionada) {
    return respuestas[respuestaSeleccionada].esCorrecta;
  }

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    var respuestasJson = json['respuestas'] as List;
    List<Respuesta> respuestasList =
        respuestasJson.map((i) => Respuesta.fromJson(i)).toList();

    return Pregunta(
      id: json['id'],
      pregunta: json['pregunta'],
      tematica: json['tematica'],
      respuestas: respuestasList,
    );
  }

  static Pregunta clone(Pregunta currentPregunta) {
    List<Respuesta> clonedRespuestas = currentPregunta.respuestas
        .map((respuesta) => Respuesta(
              id: respuesta.id,
              respuesta: respuesta.respuesta,
              esCorrecta: respuesta.esCorrecta,
              pregunta: respuesta.pregunta,
            ))
        .toList();

    return Pregunta(
      id: currentPregunta.id,
      pregunta: currentPregunta.pregunta,
      tematica: currentPregunta.tematica,
      respuestas: clonedRespuestas,
    );
  }

  @override
  String toString() {
    return 'Pregunta: {texto: $pregunta, respuesta: $respuestas}';
  }
}
