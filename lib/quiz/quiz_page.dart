import 'package:flutter/material.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/pregunta.dart';

class QuizPage extends StatefulWidget {
  final List<Pregunta> preguntas;

  QuizPage({required this.preguntas});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _selectedOption = 0;
  int _currentQuestionIndex = 0;
  bool _hasAnswered = false;
  @override
  Widget build(BuildContext context) {
    double progress = (_currentQuestionIndex + 1) / widget.preguntas.length;
    Pregunta currentQuestion = widget.preguntas[_currentQuestionIndex];
    bool isCorrect = currentQuestion.esCorrecta(_selectedOption);
    // Variable para saber si se ha respondido la pregunta
    return Scaffold(
      appBar: AppBar(
        //quiero que el titulo de la pagina sea el que se elija en el menu pop anterior,
        //title: const Text('Quiz '),pregunta.tematica.
        title: Text('Quiz ${currentQuestion.tematica}'),
        // backgroundColor: Colors.indigoAccent,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/quiz.jpg'), // Imagen de fondo
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                    value: progress,
                    minHeight: 20,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),
              Text(
                'Pregunta ${_currentQuestionIndex + 1}/${widget.preguntas.length}',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 500,
                ),
                child: Container(
                    decoration: BoxDecoration(
                      //color: const Color.fromARGB(255, 184, 8, 253), // Color de fondo de los hijos
                      color: Colors.orange[200],
                      borderRadius: BorderRadius.circular(
                          10), // Borde redondeado de la caja
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: Card(
                        color: Colors.deepPurple[100],
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: const EdgeInsets.all(15),
                              child: Text(
                                currentQuestion.pregunta,
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(
                              color: Colors.black,
                              thickness: 1,
                            ),
                            const SizedBox(height: 40),
                            Flexible(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  height: 500,
                                  child: GridView.count(
                                    crossAxisCount: 1,
                                    childAspectRatio: 6,
                                    mainAxisSpacing: 20,
                                    children: List.generate(
                                        currentQuestion.respuestas.length,
                                        (index) {
                                      return InkWell(
                                        onTap: !_hasAnswered
                                            ? () {
                                                setState(() {
                                                  _selectedOption = index;
                                                  _hasAnswered = true;
                                                  isCorrect = currentQuestion
                                                      .respuestas[index]
                                                      .isCorrect;
                                                });
                                              }
                                            : null,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: BoxDecoration(
                                            color: _hasAnswered &&
                                                    _selectedOption == index
                                                ? isCorrect
                                                    ? Colors.green
                                                    : Colors.red
                                                : Colors.orange[
                                                    300], // Cambia el color de fondo cuando se selecciona una opción
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: Center(
                                            child: ListTile(
                                              title: Text(
                                                currentQuestion
                                                    .respuestas[index]
                                                    .respuesta,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                              leading: Image.asset(
                                                  'assets/atomo.png'), // Cambia IconButton por Image.asset
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))),
              ),
              PersonalizadorWidget.buildCustomElevatedButton("Siguiente",
                  () async {
                if (_currentQuestionIndex < widget.preguntas.length - 1) {
                  setState(() {
                    _currentQuestionIndex++;
                    _selectedOption = 0; // Reset selected option
                  });
                } else {
                  // Quiz is finished, navigate to another page or show a dialog
                }
              }),
              SizedBox(height: 35),
            ],
          )),
    );
  }
}
