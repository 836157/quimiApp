import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeData themeData;
  late ThemeData secondTheme;
  ThemeData? currentTheme;
  ThemeNotifier() {
    themeData = ThemeData(
      //propiedades del tema primario
      primaryColor:
          const Color.fromARGB(255, 182, 233, 134), // Un tono de verde
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
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors
                .black; // Color de fondo cuando el Checkbox está seleccionado
          }
          return Colors
              .white; // Color de fondo cuando el Checkbox no está seleccionado
        }),
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
        secondary: Color.fromARGB(255, 117, 170, 56), // Otro tono de verde
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
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors
                .black; // Color de fondo cuando el Checkbox está seleccionado
          }
          return Colors
              .white; // Color de fondo cuando el Checkbox no está seleccionado
        }),
        checkColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors
                .white; // Color del check cuando el Checkbox está seleccionado
          }
          return null; // Dejar el color predeterminado cuando el Checkbox no está seleccionado
        }),
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

  getTheme() => currentTheme;
  getSecondTheme() => secondTheme;

  bool _isUsingFirstTheme = true;
  bool get isUsingFirstTheme => _isUsingFirstTheme;

  bool isSecondTheme() {
    return currentTheme == secondTheme;
  }

  setTheme() {
    if (_isUsingFirstTheme) {
      currentTheme = secondTheme;
    } else {
      currentTheme = ThemeData(
          //propiedades del tema primario
          primaryColor:
              const Color.fromARGB(255, 182, 233, 134), // Un tono de verde
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
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return Colors
                    .black; // Color de fondo cuando el Checkbox está seleccionado
              }
              return Colors
                  .white; // Color de fondo cuando el Checkbox no está seleccionado
            }),
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
            secondary: Color.fromARGB(255, 117, 170, 56), // Otro tono de verde
          ));
    }

    _isUsingFirstTheme = !_isUsingFirstTheme;
    notifyListeners();
  }
}
