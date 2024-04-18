import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quimicapp/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/humo.gif"), // Cambia esto por la ruta a tu imagen de fondo
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido
          FocusScope(
            node: FocusScopeNode(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Animación Lottie
                  Lottie.asset(
                    'assets/animacion.json', // Cambia esto por la ruta a tu animación Lottie
                    controller: _controller,
                    onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..forward();
                      Future.delayed(_controller.duration!).then((_) {
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                          );
                        }
                      });
                    },
                  ),
                  const Text(
                    'qUimiCapP',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'splashScreen',
                      color: Colors.white,
                      fontSize: 64,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
