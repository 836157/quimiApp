import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quimicapp/authentication_service.dart';
import 'package:quimicapp/splash_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthenticationService(),
      child: const MyApp(),
    ),
  );
}
/*0 */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.black;
    const secondaryColor = Colors.green;
    final appBarColor = Colors.green[600];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuimicApp',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: primaryColor, // Color primario negro
        colorScheme: const ColorScheme.dark(
          secondary: secondaryColor, // Color secundario verde
        ),
        appBarTheme: AppBarTheme(
          color: appBarColor,
          elevation: 10.0, // Ajusta la elevación aquí
          shadowColor: Colors.white,
          toolbarTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 12,
            letterSpacing: 6.0,
          ), // Título de AppBar blanco
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
            fontSize: 22,
            letterSpacing: 7.0,
          ), // Título de AppBar blanco
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
