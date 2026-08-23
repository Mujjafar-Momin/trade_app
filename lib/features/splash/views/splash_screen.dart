import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trading_app/trade_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeIn;
  late final Animation<double> _scaleIn;

  late final AnimationController _pulseController;
  late final Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fadeIn = CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    _scaleIn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutBack),
    );

    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return GetBuilder<SplashController>(builder: (context) {
      return Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [colors.background, colors.primary.withValues(alpha: .05)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: Listenable.merge([_entranceController, _pulseController]),
                      builder: (context, child) {
                        return Opacity(
                          opacity: _fadeIn.value,
                          child: Transform.scale(
                            scale: _scaleIn.value * _pulseScale.value,
                            child: child,
                          ),
                        );
                      },
                      child: const _LogoImage(),
                    ),
                    const SizedBox(height: 44),
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Text(
                        'Practice trading with real-time simulated markets',
                        style: AppTextStyles.medium14.copyWith(color: colors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _LogoImage extends StatelessWidget {
  const _LogoImage();

  @override
  Widget build(BuildContext context) {
    final logoWidth = (MediaQuery.sizeOf(context).width * 0.58).clamp(180.0, 260.0);

    return Material(
      elevation: 16,
      shadowColor: Colors.black.withValues(alpha: .35),
      borderRadius: BorderRadius.circular(28),
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      child: Image.asset(
        'assets/images/app_logo.png',
        width: logoWidth,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: logoWidth,
            height: logoWidth,
            color: const Color(0xFF0B1220),
            alignment: Alignment.center,
            child: const Icon(Icons.candlestick_chart_rounded, color: Colors.white, size: 56),
          );
        },
      ),
    );
  }
}
