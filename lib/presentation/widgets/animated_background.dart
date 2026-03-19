import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  final String? imageUrl;
  final bool showImage;

  const AnimatedBackground({
    super.key,
    required this.child,
    this.imageUrl,
    this.showImage = true,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: WaveBackgroundPainter(
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
        if (widget.showImage && widget.imageUrl != null)
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                AppColors.primaryDark.withValues(alpha: 0.3),
                BlendMode.darken,
              ),
              child: Image.network(
                widget.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.backgroundGradient,
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.backgroundGradient,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),
        Container(
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
        widget.child,
      ],
    );
  }
}

class WaveBackgroundPainter extends CustomPainter {
  final double animationValue;

  WaveBackgroundPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.backgroundStart.withValues(alpha: 0.5),
          AppColors.primaryLight.withValues(alpha: 0.3),
          AppColors.primary.withValues(alpha: 0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final waveHeight = size.height * 0.15;
    final yOffset = size.height * 0.7;

    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = yOffset +
          sin((x / size.width * 2 * pi) + (animationValue * 2 * pi)) *
              waveHeight *
          0.5 +
          sin((x / size.width * 4 * pi) + (animationValue * 2 * pi * 1.5)) *
              waveHeight *
              0.3;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    final paint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accent.withValues(alpha: 0.2),
          AppColors.primaryLight.withValues(alpha: 0.1),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path2 = Path();
    final waveHeight2 = size.height * 0.1;
    final yOffset2 = size.height * 0.8;

    path2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = yOffset2 +
          sin((x / size.width * 3 * pi) + (animationValue * 2 * pi * 0.8)) *
              waveHeight2 *
              0.4;
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(WaveBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
