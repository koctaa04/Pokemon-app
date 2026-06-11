import 'package:flutter/material.dart';

class PokemonLogoHeader extends StatelessWidget {
  const PokemonLogoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/images/logo-pokemon.png',
        height: 72,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}