import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:quimicapp/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5)).then((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });

    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'QuimicApp',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20), // Espacio entre el título y la animación
            AtomAnimation(),
            SizedBox(height: 200),
            Center(
              child: Text(
                'Realizado por Sebastián Olea Castillo\nAll rights reserved.2024',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AtomAnimation extends HookWidget {
  const AtomAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller1 =
        useAnimationController(duration: const Duration(seconds: 2))..repeat();
    final controller2 =
        useAnimationController(duration: const Duration(seconds: 3))..repeat();
    final controller3 =
        useAnimationController(duration: const Duration(seconds: 4))..repeat();
    final controller4 =
        useAnimationController(duration: const Duration(seconds: 5))..repeat();

    return Stack(
      alignment: Alignment.center,
      children: [
        _buildOrbit(100),
        _buildOrbit(120),
        _buildOrbit(140),
        _buildOrbit(160),
        _buildElectron(controller1, 0, Colors.blue, 100),
        _buildElectron(controller2, 2 / 3 * pi, Colors.green, 120),
        _buildElectron(controller3, 4 / 3 * pi, Colors.yellow, 140),
        _buildElectron(controller4, 2 * pi, Colors.purple, 160),
        _buildNucleus(),
      ],
    );
  }

  Widget _buildOrbit(double radius) {
    return Container(
      width: 2 * radius,
      height: 2 * radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2), // Semi-transparent white
      ),
    );
  }

  Widget _buildElectron(AnimationController controller, double startRadians,
      Color color, double radius) {
    final animation = CurvedAnimation(parent: controller, curve: Curves.linear);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final angle = 2 * pi * animation.value + startRadians;
        final dx = radius * cos(angle);
        final dy = radius * sin(angle);

        // Cambia el tamaño y la opacidad basándose en el ángulo para simular un efecto 3D
        final size = 20 + 10 * sin(angle);
        final opacity = 0.4 + 0.6 * (cos(angle) + 1) / 2;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNucleus() {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }
}
