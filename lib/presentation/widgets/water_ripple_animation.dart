import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class WaterRipplePainter extends CustomPainter {
  final double animationValue;

  WaterRipplePainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) * 0.8;

    for (int i = 0; i < 4; i++) {
      final rippleProgress = (animationValue + i * 0.25) % 1.0;
      final radius = maxRadius * rippleProgress;
      final opacity = (1.0 - rippleProgress) * 0.3;

      final paint = Paint()
        ..color = AppColors.accent.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0 - rippleProgress * 2;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(WaterRipplePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class WaterRippleAnimation extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const WaterRippleAnimation({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<WaterRippleAnimation> createState() => _WaterRippleAnimationState();
}

class _WaterRippleAnimationState extends State<WaterRippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.enabled)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: WaterRipplePainter(animationValue: _animation.value),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}
