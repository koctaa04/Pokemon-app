import 'package:flutter/material.dart';

class PokemonLogoHeader extends StatelessWidget {
  const PokemonLogoHeader({
    super.key,
    this.height = 72,
    this.heroTag = 'pokemon-logo-hero',
  });

  final double height;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Hero(
        tag: heroTag,
        child: Material(
          type: MaterialType.transparency,
          child: Image.asset(
            'assets/images/logo-pokemon.png',
            height: height,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}