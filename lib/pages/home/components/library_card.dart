import 'package:flutter/material.dart';

class LibraryCard extends StatelessWidget {
  const LibraryCard({
    super.key,
    this.icon = Icons.menu_book_rounded,
    this.iconSize = 80,
    this.iconColor = Colors.white,
    this.title = 'E-Library',
    this.titleStyle,
    this.gradientColors = const [Color(0xFF1E88E5), Color(0xFF1565C0)],
    this.borderColor = Colors.white70,
    this.borderWidth = 1.5,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 6.0,
    this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String title;
  final TextStyle? titleStyle;
  final List<Color> gradientColors;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsets padding;
  final double elevation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..scale(onTap != null ? 1.0 : 0.98),
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: borderColor, width: borderWidth),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: elevation,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: iconColor),
            const SizedBox(height: 8),
            Text(
              title,

              style:
                  titleStyle ??
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(0, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
