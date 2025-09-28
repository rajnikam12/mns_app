import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final Widget nextScreen;
  final String logoPath;
  final Duration duration;
  final Color backgroundColor;

  const SplashScreen({
    super.key,
    required this.nextScreen,
    required this.logoPath,
    this.duration = const Duration(seconds: 3),
    this.backgroundColor = Colors.deepOrange,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _revealController;
  late AnimationController _flipController;
  late AnimationController _textController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _revealAnimation;
  late Animation<double> _flipAnimation;
  late Animation<double> _textFadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _revealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeInExpo),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    // Start animations
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _flipController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _textController.forward();
    });

    // Navigate after duration
    Timer(widget.duration, () {
      if (mounted) {
        _revealController.forward().then((_) {
          Get.off(
            () => widget.nextScreen,
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 1000),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _revealController.dispose();
    _flipController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.backgroundColor,
              widget.backgroundColor,
              widget.backgroundColor,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _bounceAnimation,
                  child: AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(pi * (1.0 - _flipAnimation.value)),
                        alignment: Alignment.center,
                        child: Image.asset(
                          widget.logoPath,
                          height: 400,
                          width: 400,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.error,
                                size: 100,
                                color: Colors.white,
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
