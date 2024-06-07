import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/elemento.dart';
import 'package:quimicapp/themeAppDark/themenotifier.dart';
import 'package:text_neon_widget/text_neon_widget.dart';

class PersonalizadorWidget {
  static TextFormField buildCustomTextFormField(
      {required BuildContext context,
      required TextEditingController controller,
      required String labelText,
      required IconData icon,
      int? maxLines,
      bool expands = false,
      Color? iconColor,
      bool obscureText = false,
      Widget? suffixIcon,
      String? Function(String?)? validator}) {
    bool isObscure = labelText == 'Contraseña';
    return TextFormField(
      controller: controller,
      maxLines: obscureText ? 1 : (expands ? null : maxLines),
      minLines: expands ? null : 1,
      expands: expands && !obscureText,
      obscureText: obscureText,
      obscuringCharacter: '*',
      style: const TextStyle(
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
      decoration: InputDecoration(
        hintText: labelText, // Cambia labelText a hintText
        hintStyle: const TextStyle(
          // Cambia labelStyle a hintStyle
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
        prefixIcon:
            Icon(icon, color: iconColor ?? Theme.of(context).iconTheme.color),
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: suffixIcon,
      ),
      validator: validator ??
          (value) {
            // Usa el validador proporcionado o el por defecto
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa tu $labelText';
            }
            return null;
          },
    );
  }

  static Widget buildCustomElevatedButton(
      BuildContext context, String buttonText, VoidCallback onPressed) {
    ThemeData theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    return SizedBox(
      width: 200, // Ancho del botón
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: themeNotifier
                      .isUsingFirstTheme // Utiliza el método isSecondTheme()
                  ? Colors.white
                  : Colors.red,
              spreadRadius: 1,
              blurRadius: 16,
              offset: const Offset(0, 1),
            ),
          ],
          gradient: LinearGradient(
            colors: [
              theme.primaryColor, // Un tono de verde
              theme.colorScheme.secondary, // Otro tono de verde
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
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
                child: Text(
                  buttonText,
                  style: TextStyle(
                    color: themeNotifier.isUsingFirstTheme
                        ? Colors.black
                        : Colors.white, // Color del texto según el tema
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

  static buildGradientAppBar(
      {required String title,
      required BuildContext context,
      List<Widget>? actions}) {
    ThemeData theme = Provider.of<ThemeNotifier>(context).currentThemeGet()!;
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.primaryColor, // Color primario del tema
              theme.colorScheme.secondary, // Color secundario del tema
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ), // Aumenta el tamaño del texto aquí
          ),
          actions: actions,
        ),
      ),
    );
  }

  static buildGradientBottomNavigationBar(
      {required BuildContext context, required Function(int) onTap}) {
    ThemeData theme = Provider.of<ThemeNotifier>(context).currentThemeGet()!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.primaryColor, // Color primario del tema
            theme.colorScheme.secondary, // Color secundario del tema
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          unselectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Usuarios en línea',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Ajustes',
            ),
          ],
          onTap: onTap,
        ),
      ),
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
