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

Color pokemonTypeColor(String? type) {
  switch ((type ?? '').toLowerCase()) {
    case 'grass':
      return const Color(0xFF4CAF50);
    case 'fire':
      return const Color(0xFFF97316);
    case 'water':
      return const Color(0xFF3B82F6);
    case 'electric':
      return const Color(0xFFFACC15);
    case 'psychic':
      return const Color(0xFFA855F7);
    case 'ice':
      return const Color(0xFF22D3EE);
    case 'dragon':
      return const Color(0xFF6366F1);
    case 'fairy':
      return const Color(0xFFF472B6);
    case 'ghost':
      return const Color(0xFF64748B);
    case 'dark':
      return const Color(0xFF475569);
    case 'poison':
      return const Color(0xFF8B5CF6);
    case 'ground':
      return const Color(0xFFD97706);
    case 'rock':
      return const Color(0xFFB45309);
    case 'bug':
      return const Color(0xFF84CC16);
    case 'steel':
      return const Color(0xFF94A3B8);
    case 'fighting':
      return const Color(0xFFEF4444);
    case 'flying':
      return const Color(0xFF38BDF8);
    case 'normal':
      return const Color(0xFF94A3B8);
    default:
      return const Color(0xFF64748B);
  }
}

List<Color> pokemonTypeGradientForType(String? type) {
  switch ((type ?? '').toLowerCase()) {
    case 'grass':
      return const [Color(0xFF7EE081), Color(0xFF1A8B53)];
    case 'fire':
      return const [Color(0xFFFFB347), Color(0xFFE53935)];
    case 'water':
      return const [Color(0xFF66B2FF), Color(0xFF1E5EFF)];
    case 'electric':
      return const [Color(0xFFFFD54F), Color(0xFFFFA000)];
    case 'psychic':
      return const [Color(0xFFC084FC), Color(0xFF7C3AED)];
    case 'ice':
      return const [Color(0xFF8DEBFF), Color(0xFF22B8CF)];
    case 'dragon':
      return const [Color(0xFF7C83FF), Color(0xFF4451D4)];
    case 'fairy':
      return const [Color(0xFFFFA6C9), Color(0xFFEC4899)];
    case 'ghost':
      return const [Color(0xFF7C8AA5), Color(0xFF4C5A78)];
    case 'dark':
      return const [Color(0xFF5A6475), Color(0xFF1F2937)];
    case 'poison':
      return const [Color(0xFFB388FF), Color(0xFF7E22CE)];
    case 'ground':
      return const [Color(0xFFF7C88B), Color(0xFFD97706)];
    case 'rock':
      return const [Color(0xFFE2C6A4), Color(0xFF9A5F2A)];
    case 'bug':
      return const [Color(0xFFB8F27A), Color(0xFF65A30D)];
    case 'steel':
      return const [Color(0xFFD1D5DB), Color(0xFF64748B)];
    case 'fighting':
      return const [Color(0xFFFF8A80), Color(0xFFE11D48)];
    case 'flying':
      return const [Color(0xFF93C5FD), Color(0xFF2563EB)];
    case 'normal':
      return const [Color(0xFFB7C0D1), Color(0xFF6B7280)];
    default:
      return const [Color(0xFF8EA7FF), Color(0xFF3B4DAD)];
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