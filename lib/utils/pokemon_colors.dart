import 'package:flutter/material.dart';

Color pokemonCardColorForType(String? type) {
  switch ((type ?? '').toLowerCase()) {
    case 'grass':
      return const Color(0xFFE8F8EC);
    case 'fire':
      return const Color(0xFFFFEAD9);
    case 'water':
      return const Color(0xFFE2F1FF);
    case 'electric':
      return const Color(0xFFFFF7CC);
    case 'psychic':
      return const Color(0xFFF1E4FF);
    case 'rock':
      return const Color(0xFFF5E4D5);
    case 'ice':
      return const Color(0xFFE1FBFF);
    case 'dragon':
      return const Color(0xFFE4E8FF);
    case 'fairy':
      return const Color(0xFFFFE0EF);
    default:
      return const Color(0xFFF2F3F7);
  }
}

Color pokemonCardTitleColorForType(String? type) {
  switch ((type ?? '').toLowerCase()) {
    case 'grass':
      return const Color(0xFF1F6B3A);
    case 'fire':
      return const Color(0xFFB24A1E);
    case 'water':
      return const Color(0xFF1E5AA8);
    case 'electric':
      return const Color(0xFF947200);
    case 'psychic':
      return const Color(0xFF7A3FA6);
    case 'rock':
      return const Color(0xFF8B5E3C);
    case 'ice':
      return const Color(0xFF0F7C8C);
    case 'dragon':
      return const Color(0xFF4250C8);
    case 'fairy':
      return const Color(0xFFB84A7A);
    default:
      return const Color(0xFF374151);
  }
}

Color pokemonCategoryBadgeColor(String category) {
  switch (category) {
    case 'Special':
      return const Color(0xFFE67E22);
    case 'Rare':
      return const Color(0xFF2F80ED);
    case 'Legendary':
      return const Color(0xFF4B5563);
    default:
      return const Color(0xFF9CA3AF);
  }
}