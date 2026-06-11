import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'home_screen.dart';
import '../widgets/animated_pokeball.dart';
import '../widgets/glass_card.dart';
import '../widgets/pokemon_logo_header.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _rotationController;
  Timer? _navigationTimer;
  Timer? _rotationStartTimer;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..forward();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _rotationStartTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _rotationController.repeat();
      }
    });

    _navigationTimer = Timer(const Duration(milliseconds: 2500), _goToHome);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _rotationStartTimer?.cancel();
    _entranceController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  void _goToHome() {
    if (!mounted) {
      return;
    }

    Navigator.of(context).pushReplacement(_buildRoute());
  }

  PageRouteBuilder<void> _buildRoute() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 700),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final slide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero).animate(fade);

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompact = size.height < 700;
    final contentWidth = math.min(size.width - 40, 420.0);

    final logoOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.12, 0.30, curve: Curves.easeOut),
    );
    final pokeballScale = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.32, 0.62, curve: Curves.elasticOut),
    );
    final subtitleOpacity = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.48, 0.72, curve: Curves.easeOut),
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF4B0F14), Color(0xFFB91C1C), Color(0xFFFF6B6B)],
            stops: [0.0, 0.56, 1.0],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -80,
              left: -50,
              child: _BackgroundCircle(size: size.width * 0.42, opacity: 0.08),
            ),
            Positioned(
              top: 120,
              right: -30,
              child: _BackgroundCircle(size: size.width * 0.24, opacity: 0.1),
            ),
            Positioned(
              bottom: 120,
              left: -40,
              child: _BackgroundCircle(size: size.width * 0.30, opacity: 0.06),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.07,
                  child: Center(
                    child: AnimatedPokeball(
                      size: math.min(size.width, size.height) * 1.18,
                      rotationTurns: 0,
                    ),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PatternPainter(),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: isCompact ? 20 : 24, vertical: 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: contentWidth),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 14 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: GlassCard(
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 22 : 28,
                          vertical: isCompact ? 28 : 34,
                        ),
                        borderRadius: 34,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeTransition(
                              opacity: logoOpacity,
                              child: const PokemonLogoHeader(
                                height: 118,
                                heroTag: 'pokemon-logo-hero',
                              ),
                            ),
                            SizedBox(height: isCompact ? 18 : 22),
                            AnimatedBuilder(
                              animation: Listenable.merge(<Listenable>[_entranceController, _rotationController]),
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: pokeballScale.value,
                                  child: AnimatedPokeball(
                                    size: isCompact ? 132 : 154,
                                    rotationTurns: _rotationController.value,
                                    opacity: 1,
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: isCompact ? 16 : 22),
                            FadeTransition(
                              opacity: subtitleOpacity,
                              child: Text(
                                'Explore the World of Pokémon',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.white.withOpacity(0.92),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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

class _BackgroundCircle extends StatelessWidget {
  const _BackgroundCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
        border: Border.all(color: Colors.white.withOpacity(opacity * 1.2), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var index = 0; index < 5; index++) {
      final radius = 36.0 + (index * 18.0);
      final center = Offset(size.width * (0.12 + index * 0.18), size.height * (0.18 + (index.isEven ? 0.04 : 0.14)));
      canvas.drawCircle(center, radius, paint);
    }

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.035)
      ..strokeWidth = 1.2;
    canvas.drawLine(
      Offset(0, size.height * 0.22),
      Offset(size.width, size.height * 0.22),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}