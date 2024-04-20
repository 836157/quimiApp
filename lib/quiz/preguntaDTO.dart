import 'respuestaDTO.dart';

class PreguntaDTO {
  final String pregunta;
  final String tematica;
  final List<RespuestaDTO> respuestas;

  PreguntaDTO({
    required this.pregunta,
    required this.tematica,
    required this.respuestas,
  });

  esCorrecta(int respuestaSeleccionada) {
    return respuestas[respuestaSeleccionada].esCorrecta;
  }

  factory PreguntaDTO.fromJson(Map<String, dynamic> json) {
    var respuestasJson = json['respuestas'] as List;
    List<RespuestaDTO> respuestasList =
        respuestasJson.map((i) => RespuestaDTO.fromJson(i)).toList();

    return PreguntaDTO(
      pregunta: json['pregunta'],
      tematica: json['tematica'],
      respuestas: respuestasList,
    );
  }

  Map<String, dynamic> toJson() => {
        'pregunta': pregunta,
        'respuestas':
            respuestas.map((respuesta) => respuesta.toJson()).toList(),
        'tematica': tematica,
      };

  static PreguntaDTO clone(PreguntaDTO currentPregunta) {
    List<RespuestaDTO> clonedRespuestas = currentPregunta.respuestas
        .map((respuesta) => RespuestaDTO(
              respuesta: respuesta.respuesta,
              esCorrecta: respuesta.esCorrecta,
            ))
        .toList();

    return PreguntaDTO(
      pregunta: currentPregunta.pregunta,
      tematica: currentPregunta.tematica,
      respuestas: clonedRespuestas,
    );
  }

  @override
  String toString() {
    return 'Pregunta: {texto: $pregunta, respuesta: $respuestas}';
  }

  int obtenerRespuestaCorrecta() {
    for (int i = 0; i < respuestas.length; i++) {
      if (respuestas[i].esCorrecta) {
        return i;
      }
    }
    return -1; // Devuelve -1 si no hay respuesta correcta
  }
}
