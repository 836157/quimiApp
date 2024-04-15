import 'package:flutter/material.dart';

class PersonalizadorWidget {
  static TextFormField buildCustomTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        prefixIcon: Icon(icon),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      obscureText: labelText == 'Contraseña',
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingresa tu $labelText';
        }
        return null;
      },
    );
  }

  static buildCustomElevatedButton(String buttonText, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color:
                Colors.blueGrey, // Cambia esto al color de sombra que prefieras
            spreadRadius: 5,
            blurRadius: 5,
            offset: Offset(
                0, 3), // Cambia esto para cambiar la posición de la sombra
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.indigoAccent[400],
          minimumSize: const Size(250, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // borde redondeado
          ),
        ),
        child: Text(buttonText),
      ),
    );
  }
}
