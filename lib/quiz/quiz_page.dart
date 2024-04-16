import 'package:flutter/material.dart';
import 'package:quimicapp/personalizadorwidget.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //quiero que el titulo de la pagina sea el que se elija en el menu pop anterior,
        title: const Text('Quiz '),
      ),
    );
  }
}
