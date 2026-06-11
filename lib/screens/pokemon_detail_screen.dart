import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/pokemon_model.dart';
import '../services/pokemon_service.dart';
import '../utils/pokemon_colors.dart';
import '../widgets/favorite_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/pokemon_type_chip.dart';
import '../widgets/stat_bar.dart';

class PokemonDetailScreen extends StatefulWidget {
  const PokemonDetailScreen({
    super.key,
    required this.name,
    required this.detailUrl,
  });

  final String name;
  final String detailUrl;

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen>
    with SingleTickerProviderStateMixin {
  final PokemonService _service = PokemonService();
  late final Future<PokemonDetail> _pokemonFuture;
  late final AnimationController _floatingController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _service.fetchPokemonDetail(widget.detailUrl);
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<PokemonDetail>(
        future: _pokemonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState(context);
          }

          if (snapshot.hasError) {
            return _buildErrorState(context, snapshot.error);
          }

          final pokemon = snapshot.data;

          if (pokemon == null) {
            return _buildErrorState(context, 'No Pokémon detail available.');
          }

          return _DetailScaffold(
            name: widget.name,
            detailUrl: widget.detailUrl,
            pokemon: pokemon,
            floatingController: _floatingController,
            isFavorite: _isFavorite,
            onFavoritePressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final gradient = pokemonTypeGradientForType('normal');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradient,
        ),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object? error) {
    final gradient = pokemonTypeGradientForType('normal');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradient,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: GlassCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline_rounded, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    'Unable to load Pokémon details.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
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
}

class _DetailScaffold extends StatelessWidget {
  const _DetailScaffold({
    required this.name,
    required this.detailUrl,
    required this.pokemon,
    required this.floatingController,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  final String name;
  final String detailUrl;
  final PokemonDetail pokemon;
  final AnimationController floatingController;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.isNotEmpty ? pokemon.types.first.name : 'normal';
    final gradientColors = pokemonTypeGradientForType(primaryType);
    final pokemonId = _formatPokemonId(_extractPokemonId(detailUrl));
    final heroTag = 'pokemon-${_extractPokemonId(detailUrl)}';
    final heroWidth = _heroWidth(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: -44,
                top: 92,
                child: _DecorativeBlob(
                  size: 180,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
              Positioned(
                right: -30,
                top: 180,
                child: _DecorativeBlob(
                  size: 140,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  children: [
                    _TopBar(
                      onBack: () => Navigator.of(context).maybePop(),
                      isFavorite: isFavorite,
                      onFavoritePressed: onFavoritePressed,
                    ),
                    const SizedBox(height: 18),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 720),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 18 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: heroWidth + 104,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Opacity(
                                  opacity: 0.08,
                                  child: _PokeballDecoration(size: heroWidth + 126),
                                ),
                                AnimatedBuilder(
                                  animation: floatingController,
                                  builder: (context, child) {
                                    final offset = math.sin(floatingController.value * math.pi * 2) * 8;

                                    return Transform.translate(
                                      offset: Offset(0, offset),
                                      child: child,
                                    );
                                  },
                                  child: Hero(
                                    tag: heroTag,
                                    child: pokemon.imageUrl.isEmpty
                                        ? Icon(
                                            Icons.catching_pokemon_rounded,
                                            size: heroWidth * 0.82,
                                            color: Colors.white.withOpacity(0.95),
                                          )
                                        : Image.network(
                                            pokemon.imageUrl,
                                            width: heroWidth,
                                            height: heroWidth,
                                            fit: BoxFit.contain,
                                            filterQuality: FilterQuality.high,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Icon(
                                                Icons.catching_pokemon_rounded,
                                                size: heroWidth * 0.82,
                                                color: Colors.white.withOpacity(0.95),
                                              );
                                            },
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            _formatPokemonName(name),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.6,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pokemonId,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.2,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 820),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 28 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Transform.translate(
                        offset: const Offset(0, -14),
                        child: GlassCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _SectionHeader(
                                title: 'Types',
                                subtitle: 'Pokémon classification',
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: pokemon.types
                                    .map(
                                      (type) => PokemonTypeChip(
                                        label: type.name,
                                        color: pokemonTypeColor(type.name),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                              const _SectionHeader(
                                title: 'About',
                                subtitle: 'Physical details',
                              ),
                              const SizedBox(height: 14),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final tileSpacing = 10.0;
                                  final tileWidth = (constraints.maxWidth - tileSpacing * 2) / 3;

                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: tileWidth,
                                        child: InfoTile(
                                          label: 'Height',
                                          value: '${_formatMeters(pokemon.height)}m',
                                        ),
                                      ),
                                      SizedBox(width: tileSpacing),
                                      SizedBox(
                                        width: tileWidth,
                                        child: InfoTile(
                                          label: 'Weight',
                                          value: '${_formatKilograms(pokemon.weight)}kg',
                                        ),
                                      ),
                                      SizedBox(width: tileSpacing),
                                      SizedBox(
                                        width: tileWidth,
                                        child: InfoTile(
                                          label: 'Exp',
                                          value: pokemon.baseExperience.toString(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              const _SectionHeader(
                                title: 'Stats',
                                subtitle: 'Battle performance',
                              ),
                              const SizedBox(height: 14),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final itemWidth = constraints.maxWidth >= 640
                                      ? (constraints.maxWidth - 12) / 2
                                      : constraints.maxWidth;

                                  return Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: pokemon.stats
                                        .map(
                                          (stat) => SizedBox(
                                            width: itemWidth,
                                            child: StatBar(
                                              label: stat.name,
                                              value: stat.value,
                                              maxValue: 255,
                                              accentColor: Colors.white,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                              const _SectionHeader(
                                title: 'Abilities',
                                subtitle: 'Battle traits',
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: pokemon.abilities
                                    .map(
                                      (ability) => _AbilityChip(
                                        label: ability.name,
                                        isHidden: ability.isHidden,
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 24),
                              const _SectionHeader(
                                title: 'Description',
                                subtitle: 'Pokémon entry',
                              ),
                              const SizedBox(height: 14),
                              Text(
                                _descriptionText,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white.withOpacity(0.92),
                                      height: 1.45,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _extractPokemonId(String url) {
    final segments = Uri.parse(url).pathSegments.where((segment) => segment.isNotEmpty).toList();
    if (segments.isEmpty) {
      return 0;
    }

    return int.tryParse(segments.last) ?? 0;
  }

  String _formatPokemonId(int id) {
    if (id <= 0) {
      return '#---';
    }

    return '#${id.toString().padLeft(3, '0')}';
  }

  String _formatPokemonName(String value) {
    if (value.isEmpty) {
      return 'Unknown Pokémon';
    }

    return value
        .split('-')
        .map((part) => part.isEmpty ? part : part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  String _formatMeters(int value) {
    return (value / 10).toStringAsFixed(1);
  }

  String _formatKilograms(int value) {
    return (value / 10).toStringAsFixed(1);
  }

  double _heroWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 600) {
      return 280;
    }

    return (width * 0.7).clamp(220.0, 280.0);
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.onBack,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  final VoidCallback onBack;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TopBarButton(
          icon: Icons.arrow_back_ios_rounded,
          onTap: onBack,
        ),
        const Expanded(
          child: Center(
            child: _LogoHeader(),
          ),
        ),
        FavoriteButton(
          isFavorite: isFavorite,
          onPressed: onFavoritePressed,
        ),
      ],
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.16),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.24)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _LogoHeader extends StatelessWidget {
  const _LogoHeader();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo-pokemon.png',
      height: 54,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _AbilityChip extends StatelessWidget {
  const _AbilityChip({
    required this.label,
    required this.isHidden,
  });

  final String label;
  final bool isHidden;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatLabel(label),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
          ),
          if (isHidden) ...[
            const SizedBox(width: 8),
            Text(
              'Hidden',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatLabel(String value) {
    if (value.isEmpty) {
      return value;
    }

    return value
        .split('-')
        .map((part) => part.isEmpty ? part : part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }
}

class _DecorativeBlob extends StatelessWidget {
  const _DecorativeBlob({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

class _PokeballDecoration extends StatelessWidget {
  const _PokeballDecoration({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFFFF), Color(0xFFE11D48)],
                stops: [0.5, 0.5],
              ),
              border: Border.all(color: Colors.white, width: 6),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(height: 6, color: const Color(0xFF1F2937)),
          ),
          Container(
            width: size * 0.2,
            height: size * 0.2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFF1F2937), width: 6),
            ),
          ),
        ],
      ),
    );
  }
}

const String _descriptionText =
    'A polished Pokémon entry is not available from the current API response, so this screen keeps a premium placeholder ready for future species text.';