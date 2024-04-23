import 'package:flutter/material.dart';
import 'package:quimicapp/elemento.dart';
import 'package:text_neon_widget/text_neon_widget.dart';

class PersonalizadorWidget {
  static TextFormField buildCustomTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int? maxLines,
    bool expands = false,
    Color? iconColor,
  }) {
    bool isObscure = labelText == 'Contraseña';
    return TextFormField(
      controller: controller,
      maxLines: isObscure ? 1 : (expands ? null : maxLines),
      minLines: isObscure ? 1 : (expands ? null : 1),
      expands: !isObscure && expands,
      obscureText: isObscure,
      obscuringCharacter: '*',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        prefixIcon: Icon(icon, color: iconColor ?? Colors.green[600]),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu $labelText';
        }
        return null;
      },
    );
  }

  static Widget buildCustomElevatedButton(
      String buttonText, VoidCallback onPressed) {
    return SizedBox(
      width: 200, // Ancho del botón
      height: 50,

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          boxShadow: const [
            BoxShadow(
              color:
                  Colors.white, // Cambia esto al color de sombra que prefieras
              spreadRadius: 1,
              blurRadius: 16,
              offset: Offset(
                  0, 1), // Cambia esto para cambiar la posición de la sombra
            ),
          ],
          gradient: const LinearGradient(
            colors: [
              Color(0xFF4CAF50), // Un tono de verde
              Color(0xFF8BC34A), // Otro tono de verde
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: onPressed,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
              child: Center(
                // Aquí es donde cambió el código
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget neonQuiz() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PTTextNeon(
          text: 'Q U I Z',
          color: Colors.lime,
          font: "five",
          shine: true,
          fontSize: 95,
          strokeWidthTextHigh: 4,
          blurRadius: 25,
          strokeWidthTextLow: 1,
          backgroundColor: Colors.white,
          animatedChangeDuration: Duration(
              milliseconds: 150), // Duración de la animación de cambio de color
          shineDuration: Duration(seconds: 1),
        ),
      ],
    );
  }
}

class ElementCard extends StatelessWidget {
  final Elemento elemento;

  ElementCard({super.key, required this.elemento});
  final familias = {
    'Metal Alcalino': const Color.fromARGB(255, 247, 170, 192),
    'Tierra alcalina': const Color.fromARGB(255, 255, 220, 169),
    'No Metal': const Color.fromARGB(255, 192, 215, 240),
    'Metaloides': const Color.fromARGB(255, 147, 217, 245),
    'Metales de post-transición': const Color.fromARGB(255, 212, 235, 216),
    'Metales de transición': const Color.fromARGB(255, 247, 246, 204),
    'Halógenos': const Color.fromARGB(255, 224, 224, 240),
    'Gases Nobles': const Color.fromARGB(255, 225, 207, 229),
    'Lantánidos': const Color.fromARGB(255, 252, 224, 237),
    'Actínidos': const Color.fromARGB(255, 250, 191, 226),
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10.0,
      shadowColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Colors.black, Colors.green],
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                elemento.simbolo,
                style: TextStyle(
                  fontSize: 50.0,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              left: 10.0,
              child: Text(
                elemento.pesoAtomico.toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 10.0,
              right: 10.0,
              child: Text(
                elemento.numeroAtomico.toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: Text(
                elemento.electronegatividad.toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              left: 10.0,
              child: Container(
                width: 20.0,
                height: 20.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: familias[elemento.familia],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
