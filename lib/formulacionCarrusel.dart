import 'package:flutter/material.dart';

class FormulacionCarrusel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Aplicación'),
        // Personaliza la AppBar según tus necesidades
      ),
      body: PageView(
        // Configura el carrusel con las páginas deseadas
        children: [
          // Página 1
          Container(
            color: Colors.blue,
            child: Center(
              child:
                  Text('Página 1 - Información sobre formulación inorgánica'),
            ),
          ),
          // Página 2
          Container(
            color: Colors.green,
            child: Center(
              child:
                  Text('Página 2 - Información sobre formulación inorgánica'),
            ),
          ),
          // Página 3
          Container(
            color: Colors.orange,
            child: Center(
              child:
                  Text('Página 3 - Información sobre formulación inorgánica'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FormulacionCarrusel(),
  ));
}
