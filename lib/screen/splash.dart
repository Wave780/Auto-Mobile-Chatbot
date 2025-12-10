import 'dart:async';

import 'package:auto_mobile_chatbot/service/preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return; // Check if widget is still mounted

      if (kIsWeb) {
        Navigator.pushReplacementNamed(context, '/');
        return;
      }

      final bool onboardingComplete =
          PreferenceService.getOnboardingComplete();
      if (onboardingComplete) {
        Navigator.pushReplacementNamed(context, '/');
      } else {
        Navigator.pushReplacementNamed(context, '/loginScreen');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _navigationTimer
        ?.cancel(); // Cancel the timer to prevent callbacks after dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/images/logo.png',
            height: 120,
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.splitscreen),
          ),
        ),
      ),
    );
  }
}
