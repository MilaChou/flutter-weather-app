import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/session_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _sunController;
  late AnimationController _cloudController;
  late AnimationController _textController;
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();

    _sunController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await SessionService.init();

    _sunController.repeat();
    await Future.delayed(const Duration(milliseconds: 500));
    _cloudController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 2000));
    _fadeController.forward();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _sunController.dispose();
    _cloudController.dispose();
    _textController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E88E5),
      body: Center(
        child: FadeTransition(
          opacity: _fadeController.drive(Tween(begin: 1.0, end: 0.0)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Sun
              AnimatedBuilder(
                animation: _sunController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _sunController.value * 2 * math.pi,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.yellow[300]!,
                            Colors.orange[400]!,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.yellow[200]!.withOpacity(0.6),
                            blurRadius: 40,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.wb_sunny,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Animated Clouds
              AnimatedBuilder(
                animation: _cloudController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      (1 - _cloudController.value) * 100,
                      0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud,
                          size: 50,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          Icons.cloud_queue,
                          size: 35,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              // Animated Text
              FadeTransition(
                opacity: _textController,
                child: SlideTransition(
                  position: _textController.drive(
                    Tween(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOut)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'WeatherApp',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Прогноз погоды в любой точке мира',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
