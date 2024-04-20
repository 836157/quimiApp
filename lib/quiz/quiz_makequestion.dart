import 'package:flutter/material.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/quiz/preguntaDTO.dart';
import 'package:quimicapp/quiz/respuestaDTO.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizMakeQuestionScreen extends StatefulWidget {
  QuizMakeQuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuizMakeQuestionScreen> createState() => _QuizMakeQuestionScreenState();
}

class _QuizMakeQuestionScreenState extends State<QuizMakeQuestionScreen> {
  List<RespuestaDTO> respuestas = [
    RespuestaDTO(respuesta: '', esCorrecta: false),
    RespuestaDTO(respuesta: '', esCorrecta: false),
    RespuestaDTO(respuesta: '', esCorrecta: false),
    RespuestaDTO(respuesta: '', esCorrecta: false),
    // Agrega más respuestas aquí
  ];
  final questionController = TextEditingController();
  late List<TextEditingController> respuestasController;
  late PreguntaDTO pregunta;
  int? selectedAnswerIndex;

  @override
  void initState() {
    super.initState();
    respuestasController = List<TextEditingController>.generate(
      respuestas.length,
      (index) => TextEditingController(text: respuestas[index].respuesta),
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    for (var controller in respuestasController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '!Crea tú pregunta!',
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.green,
        shadowColor: Colors.grey,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF4CAF50), // Un tono de verde
                Color(0xFF8BC34A), // Otro tono de verde
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/fondoFinal.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: TextField(
                  controller: questionController,
                  maxLines: 6,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Escribe tu pregunta aquí',
                    labelStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    prefixIcon:
                        const Icon(Icons.question_mark, color: Colors.green),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                  height: 90), // Espacio entre la pregunta y las respuestas
              ...respuestas
                  .asMap()
                  .entries
                  .map((MapEntry<int, RespuestaDTO> entry) {
                int index = entry.key;
                RespuestaDTO respuesta = entry.value;
                return Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            18.0), // Asegúrate de que el radio del borde del Container coincida con el del Card
                        /*gradient: const LinearGradient(
                          colors: [
                            Color(0xFF4CAF50), // Un tono de verde
                            Color(0xFF8BC34A), // Otro tono de verde
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),*/
                      ),
                      child: Card(
                        color: selectedAnswerIndex == index
                            ? Colors.green
                            : (selectedAnswerIndex == null
                                ? Colors.black
                                : Colors
                                    .redAccent), // Cambia el color de fondo aquí
                        // Cambia el color de la sombra aquí
                        //elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              18.0), // Cambia el radio del borde aquí
                        ),

                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                ),
                                controller: respuestasController[index],
                                decoration: InputDecoration(
                                  labelText: 'Opción ${index + 1}',
                                  fillColor: Colors.white, // Fondo blanco
                                  filled:
                                      true, // Llena el campo de texto con el color de fondo
                                  prefixIcon: const Icon(Icons.question_answer,
                                      color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        16.0), // Radio del borde redondeado
                                  ),
                                  // Icono verde
                                ),
                              ),
                            ),
                            Checkbox(
                              value: respuesta.esCorrecta,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == false &&
                                      selectedAnswerIndex == index) {
                                    // Si se deselecciona la respuesta correcta, resetea selectedAnswerIndex a null
                                    selectedAnswerIndex = null;
                                  } else if (value == true) {
                                    if (selectedAnswerIndex != null) {
                                      respuestas[selectedAnswerIndex!]
                                          .esCorrecta = false;
                                    }
                                    respuesta.esCorrecta = true;
                                    selectedAnswerIndex = index;
                                  }
                                  respuesta.esCorrecta = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 45), // Espacio entre las tarjetas
                  ],
                );
              }).toList(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 110.0),
                child: SizedBox(
                  width: double.infinity,
                  child: PersonalizadorWidget.buildCustomElevatedButton(
                    "Guardar",
                    () {
                      // Verifica que el campo de la pregunta no esté vacío
                      if (questionController.text.isEmpty) {
                        _errorInfoDialog(
                            context, 'Por favor, introduce una pregunta.');
                        return;
                      }

                      // Verifica que todas las respuestas no estén vacías
                      if (respuestasController
                          .any((controller) => controller.text.isEmpty)) {
                        _errorInfoDialog(context,
                            'Por favor, introduce todas las respuestas.');
                        return;
                      }

                      // Verifica que solo una respuesta esté marcada como correcta
                      int correctAnswersCount = respuestas
                          .where((respuesta) => respuesta.esCorrecta)
                          .length;
                      if (correctAnswersCount != 1) {
                        _errorInfoDialog(context,
                            'Por favor, marca solo una respuesta como correcta.');
                        return;
                      }
                      setState(() {
                        pregunta = PreguntaDTO(
                          pregunta: questionController.text,
                          respuestas: respuestas.asMap().entries.map((entry) {
                            int index = entry.key;
                            RespuestaDTO respuesta = entry.value;
                            return RespuestaDTO(
                              respuesta: respuestasController[index].text,
                              esCorrecta: respuesta.esCorrecta,
                            );
                          }).toList(),
                          tematica: 'usuarios',
                        );
                        //print(pregunta);
                        enviarPregunta(pregunta, context);
                        questionController.clear();
                        for (TextEditingController controller
                            in respuestasController) {
                          controller.clear();
                        }
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _errorInfoDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Información'),
        content: const Text(
            'Sé original, haz buenas preguntas y sé bueno con la gramática, gracias por colaborar.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> enviarPregunta(PreguntaDTO pregunta, BuildContext context) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/quimicApp/preguntas/insertar'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(pregunta.toJson()),
  );

  if (response.statusCode == 201) {
    // Si el servidor devuelve una respuesta OK, la pregunta se envió correctamente.
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pregunta almacenada con éxito')));
  } else {
    // Si la respuesta no fue OK, lanza un error.
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al enviar la pregunta')));
    throw Exception();
  }
}
