// ignore: file_names
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/personalizadorwidget.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';

class ImageViewerScreen extends StatelessWidget {
  const ImageViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PersonalizadorWidget.buildGradientAppBar(
          title: 'Apuntes Reacciones', context: context),
      body: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return Stack(
            children: <Widget>[
              // Fondo
              Positioned.fill(
                child: themeNotifier.isUsingFirstTheme
                    ? Image.asset(
                        'assets/humo.gif',
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        'assets/humoRojo.gif',
                        fit: BoxFit.cover,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Row(
                  children: [
                    Lottie.asset('assets/iconoAtomo.json',
                        width: 50, height: 50),
                    SizedBox(width: 10), // Espacio entre el icono y el texto
                    RichText(
                      text: const TextSpan(
                        text: 'Método por Tanteo',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          decoration: TextDecoration.underline, // Subrayado
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Imagen en primer plano
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(20), // Para redondear la imagen
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          spreadRadius: 5, // Para darle sombra blanca
                          blurRadius: 7,
                          offset: Offset(0, 3), // Posición de la sombra
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20), // Para redondear la imagen
                      child: Image.asset(
                        'assets/ajusteReacciones.jpg',
                        fit: BoxFit.contain,
                        // Ajusta el tamaño de la imagen
                        width: MediaQuery.of(context).size.width *
                            1.5, // 150% del ancho de la pantalla
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
