import 'package:flutter/material.dart';

import '../utils/pokemon_colors.dart';

class PokemonListItem extends StatefulWidget {
  const PokemonListItem({
    super.key,
    required this.id,
    required this.name,
    required this.category,
    required this.primaryType,
    required this.rating,
    required this.imageUrl,
    required this.heroTag,
    required this.onTap,
  });

  final int id;
  final String name;
  final String category;
  final String primaryType;
  final double rating;
  final String imageUrl;
  final String heroTag;
  final VoidCallback onTap;

  @override
  State<PokemonListItem> createState() => _PokemonListItemState();
}

class _PokemonListItemState extends State<PokemonListItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final cardColor = pokemonCardColorForType(widget.primaryType);
    final badgeColor = pokemonCategoryBadgeColor(widget.category);
    final titleColor = pokemonCardTitleColorForType(widget.primaryType);

    return AnimatedScale(
      scale: _pressed ? 0.98 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: Material(
          color: cardColor,
          elevation: 0,
          shadowColor: Colors.black12,
          borderRadius: BorderRadius.circular(28),
          child: InkWell(
            borderRadius: BorderRadius.circular(28),
            onTap: widget.onTap,
            child: SizedBox(
              height: 116,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -12,
                    left: 18,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x22000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.category,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(18, 18, 104, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _formatName(widget.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: titleColor,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: index == 4 ? 0 : 2),
                                    child: Icon(
                                      index < widget.rating.floor()
                                          ? Icons.star_rounded
                                          : index < widget.rating
                                              ? Icons.star_half_rounded
                                              : Icons.star_border_rounded,
                                      color: const Color(0xFFF4B400),
                                      size: 16,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.rating.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF374151),
                                      height: 1.0,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: -18,
                    top: -10,
                    bottom: -6,
                    child: Hero(
                      tag: widget.heroTag,
                      child: Image.network(
                        widget.imageUrl,
                        width: 142,
                        height: 142,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 118,
                            height: 118,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.35),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.catching_pokemon,
                              size: 60,
                              color: Colors.black.withOpacity(0.28),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatName(String name) {
    if (name.isEmpty) {
      return 'Unknown Pokémon';
    }

    return name
        .split('-')
        .map((part) => part.isEmpty ? part : part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}