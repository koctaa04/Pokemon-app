import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final icon = widget.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.16),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.24)),
          ),
          child: Icon(
            icon,
            color: widget.isFavorite ? const Color(0xFFFF6B8A) : Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }
}