import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class OptionCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLarge;

  const OptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isLarge = true,
  });

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _elevationAnimation = Tween<double>(begin: 8.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Card(
            elevation: _elevationAnimation.value,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: AppColors.cardBackground.withValues(alpha: 0.95),
            child: InkWell(
              onTapDown: (_) => _controller.forward(),
              onTapUp: (_) {
                _controller.reverse();
                widget.onTap();
              },
              onTapCancel: () => _controller.reverse(),
              borderRadius: BorderRadius.circular(20),
              splashColor: AppColors.accent.withValues(alpha: 0.2),
              highlightColor: AppColors.primaryLight.withValues(alpha: 0.1),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: widget.isLarge ? 24 : 16,
                  horizontal: widget.isLarge ? 20 : 16,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(widget.isLarge ? 16 : 12),
                      decoration: BoxDecoration(
                        gradient: AppColors.waterGradient,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Colors.white,
                        size: widget.isLarge ? 32 : 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: widget.isLarge ? 18 : 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          height: 1.3,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.primary.withValues(alpha: 0.7),
                      size: widget.isLarge ? 20 : 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
