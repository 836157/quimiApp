import 'package:flutter/material.dart';

class ImageViewerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Apuntes reacciones',
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
      ),
      body: Stack(
        children: <Widget>[
          // Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/fondoFinal.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Imagen en primer plano
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Image.asset(
                    'assets/ajusteReacciones.jpg',
                    fit: BoxFit.fill,
                    // Ajusta el tamaño de la imagen
                    width: MediaQuery.of(context).size.width *
                        1.5, // 400% del ancho de la pantalla
                    height: MediaQuery.of(context)
                        .size
                        .height, // 400% de la altura de la pantalla
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
