import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeData themeData;
  late ThemeData secondTheme;
  ThemeData? currentTheme;
  ThemeNotifier() {
    themeData = ThemeData(
      //propiedades del tema primario
      primaryColor: const Color(0xFF8BC34A), // Un tono de verde
      //hintColor: Colors.lightGreen[200],
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedItemColor:
            Colors.black, // Color de los ítems no seleccionados
        selectedItemColor: Colors.black, // Color de los ítems seleccionados
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
        ),
      ),
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontFamily: 'Roboto',
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Roboto',
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.green, // Iconos en rojo
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ).copyWith(
        secondary: Color.fromARGB(255, 173, 223, 126), // Otro tono de verde
      ),
    );

    secondTheme = ThemeData.dark().copyWith(
      primaryColor: Colors.black,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        unselectedItemColor:
            Colors.white, // Color de los ítems no seleccionados
        selectedItemColor: Colors.white, // Color de los ítems seleccionados
      ),
      //hintColor: Colors.amber[100],
      colorScheme: const ColorScheme.dark(
        brightness: Brightness.light,
      ).copyWith(
        secondary: Colors.grey, // Otro tono de verde
      ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Roboto',
        ),
      ),
      textTheme: ThemeData.dark().textTheme.apply(
            fontFamily: 'Roboto',
            bodyColor: Colors.white, // Letras blancas
            displayColor: Colors.white, // Letras blancas
          ),
      iconTheme: const IconThemeData(
        color: Colors.red, // Iconos en rojo
      ),
    );

    currentTheme = themeData;
  }

  ThemeData? currentThemeGet() {
    return currentTheme;
  }

  getTheme() => themeData;
  getSecondTheme() => secondTheme;

  bool _isUsingFirstTheme = true;
  bool get isUsingFirstTheme => _isUsingFirstTheme;

  bool isSecondTheme() {
    return currentTheme == secondTheme;
  }

  setTheme() {
    if (_isUsingFirstTheme) {
      themeData = secondTheme;
    } else {
      themeData = ThemeData(
        //propiedades del tema primario
        primaryColor: const Color(0xFF4CAF50),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          unselectedItemColor:
              Colors.black, // Color de los ítems no seleccionados
          selectedItemColor: Colors.black, // Color de los ítems seleccionados
        ), // Un tono de verde
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.green, // Iconos en rojo
        ),
        scaffoldBackgroundColor: Colors.transparent,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontFamily: 'Roboto',
          ),
          bodyText2: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
        ).copyWith(
          secondary: const Color(0xFF8BC34A), // Otro tono de verde
        ),
      );
    }

    _isUsingFirstTheme = !_isUsingFirstTheme;
    notifyListeners();
  }
}
