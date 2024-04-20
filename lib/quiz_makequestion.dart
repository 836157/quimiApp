import 'package:flutter/material.dart';
import 'package:quimicapp/personalizadorwidget.dart';

class QuizMakeQuestionScreen extends StatefulWidget {
  QuizMakeQuestionScreen({super.key});

  @override
  State<QuizMakeQuestionScreen> createState() => _QuizMakeQuestionScreenState();
}

class _QuizMakeQuestionScreenState extends State<QuizMakeQuestionScreen> {
  final TextEditingController questionController = TextEditingController();

  final TextEditingController answer1Controller = TextEditingController();

  final TextEditingController answer2Controller = TextEditingController();

  final TextEditingController answer3Controller = TextEditingController();

  final TextEditingController answer4Controller = TextEditingController();

  String selectedValue = '';

  String selectedValue1 = "Verdadero";

  String selectedValue2 = "Verdadero";

  String selectedValue3 = "Verdadero";

  String selectedValue4 = "Verdadero";

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
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondoFinal.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 200.0,
                    child: PersonalizadorWidget.buildCustomTextFormField(
                      controller: questionController,
                      labelText: 'Escribe tu pregunta aquí...',
                      icon: Icons.question_answer,
                      maxLines: null, // Permite un número ilimitado de líneas
                      expands: true,
                      // Hace que el TextFormField sea el doble de alto
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildAnswerField(
                      answer1Controller, 'Respuesta 1', selectedValue1),
                  SizedBox(height: 16.0),
                  _buildAnswerField(
                      answer2Controller, 'Respuesta 2', selectedValue2),
                  SizedBox(height: 16.0),
                  _buildAnswerField(
                      answer3Controller, 'Respuesta 3', selectedValue3),
                  SizedBox(height: 16.0),
                  _buildAnswerField(
                      answer4Controller, 'Respuesta 4', selectedValue4),
                  SizedBox(height: 24.0),
                  Center(
                    child: PersonalizadorWidget.buildCustomElevatedButton(
                      "Guardar",
                      () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerField(TextEditingController controller, String labelText,
      String selectedValue) {
    return Column(
      children: [
        PersonalizadorWidget.buildCustomTextFormField(
          controller: controller,
          labelText: labelText,
          icon: Icons.edit,
          // minLines: 2, // Hace que el TextFormField sea el doble de alto
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButton<String>(
                value: selectedValue.isEmpty ? null : selectedValue,
                //value: selectedValue,
                hint: Text(
                    'Selecciona una opción'), // Se mostrará cuando selectedValue sea null
                items: ['Verdadero', 'Falso'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Text(value),
                        Icon(value == 'Verdadero' ? Icons.check : Icons.close),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              ),
            ),
            if (selectedValue !=
                null) // Solo muestra el icono si selectedValue no es null
              Icon(selectedValue == 'Verdadero' ? Icons.check : Icons.close,
                  color:
                      selectedValue == 'Verdadero' ? Colors.green : Colors.red),
          ],
        ),
      ],
    );
  }
}
