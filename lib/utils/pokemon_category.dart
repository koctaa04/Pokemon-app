import 'package:flutter/material.dart';

PokemonCategory pokemonCategoryForType(String? type) {
  switch ((type ?? '').toLowerCase()) {
    case 'fire':
    case 'electric':
      return const PokemonCategory(label: 'Special', color: Color(0xFFF59E0B));
    case 'water':
    case 'grass':
      return const PokemonCategory(label: 'Rare', color: Color(0xFF3B82F6));
    case 'dragon':
    case 'psychic':
      return const PokemonCategory(label: 'Legendary', color: Color(0xFF4B5563));
    default:
      return const PokemonCategory(label: 'Common', color: Color(0xFF9CA3AF));
  }
}

class PokemonCategory {
  const PokemonCategory({required this.label, required this.color});

  final String label;
  final Color color;
}