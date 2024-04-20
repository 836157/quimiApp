import 'package:flutter/material.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/quiz/preguntaDTO.dart';
import 'package:quimicapp/quiz/respuestaDTO.dart';
import 'package:quimicapp/respuesta.dart';

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
        title: const Text('Crea tú pregunta!'),
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
      body: SingleChildScrollView(
        child: Container(
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
                TextField(
                  controller: questionController,
                  maxLines: 4,
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
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                    prefixIcon: const Icon(
                                        Icons.question_answer,
                                        color: Colors.green), // Icono verde
                                  ),
                                ),
                              ),
                              Checkbox(
                                value: respuesta.esCorrecta,
                                onChanged: (bool? value) {
                                  setState(() {
                                    respuesta.esCorrecta = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 30), // Espacio entre las tarjetas
                    ],
                  );
                }).toList(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 158.0),
                  child: PersonalizadorWidget.buildCustomElevatedButton(
                    "Guardar",
                    () {
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
                        print(pregunta);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
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
