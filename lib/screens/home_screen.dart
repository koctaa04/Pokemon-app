import 'package:flutter/material.dart';

import '../models/pokemon_model.dart';
import '../services/pokemon_service.dart';
import '../utils/pokemon_category.dart';
import '../utils/pokemon_rating.dart';
import '../widgets/pokemon_list_item.dart';
import '../widgets/pokemon_logo_header.dart';
import '../widgets/pokemon_search_bar.dart';
import 'pokemon_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.service});

  final PokemonService? service;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PokemonService _service = widget.service ?? PokemonService();
  late Future<List<_PokemonCardData>> _pokemonFuture;
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _loadPokemonCards();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<_PokemonCardData>> _loadPokemonCards() async {
    final summaries = await _service.fetchPokemonList();

    return Future.wait(
      summaries.map((summary) async {
        final id = _extractPokemonId(summary.url);
        String primaryType = 'normal';

        try {
          final detail = await _service.fetchPokemonDetail(summary.url);
          if (detail.types.isNotEmpty) {
            primaryType = detail.types.first.name;
          }
        } catch (_) {
          primaryType = 'normal';
        }

        return _PokemonCardData(
          id: id,
          name: summary.name,
          detailUrl: summary.url,
          primaryType: primaryType,
          category: pokemonCategoryForType(primaryType).label,
          rating: pokemonRatingForId(id),
          imageUrl: _buildArtworkUrl(id),
        );
      }),
    );
  }

  int _extractPokemonId(String url) {
    final segments = Uri.parse(url).pathSegments.where((segment) => segment.isNotEmpty).toList();
    if (segments.isEmpty) {
      return 0;
    }

    return int.tryParse(segments.last) ?? 0;
  }

  String _buildArtworkUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim().toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = MediaQuery.of(context).size.width >= 600 ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<List<_PokemonCardData>>(
          future: _pokemonFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () {
                  setState(() {
                    _searchQuery = '';
                    _searchController.clear();
                    _pokemonFuture = _loadPokemonCards();
                  });
                },
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const _LoadingState();
            }

            final pokemon = snapshot.data ?? const <_PokemonCardData>[];
            final filteredPokemon = pokemon.where((item) {
              final matchesSearch = _searchQuery.isEmpty || item.name.toLowerCase().contains(_searchQuery);
              final matchesCategory =
                  _selectedCategory == 'All' || item.category == _selectedCategory;

              return matchesSearch && matchesCategory;
            }).toList(growable: false);

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 18, horizontalPadding, 0),
                  child: const PokemonLogoHeader(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 22, horizontalPadding, 0),
                  child: PokemonSearchBar(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 42,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categoryOptions.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = _categoryOptions[index];
                      final isSelected = category == _selectedCategory;

                      return ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF374151),
                          fontWeight: FontWeight.w700,
                        ),
                        selectedColor: const Color(0xFFE53935),
                        backgroundColor: const Color(0xFFF3F4F6),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredPokemon.isEmpty
                      ? const _EmptyState()
                      : TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 360),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 14 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(horizontalPadding, 4, horizontalPadding, 24),
                            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                            itemCount: filteredPokemon.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = filteredPokemon[index];

                              return Padding(
                                padding: const EdgeInsets.only(top: 18),
                                child: TweenAnimationBuilder<double>(
                                  key: ValueKey(item.id),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  duration: Duration(milliseconds: 240 + (index * 40)),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, itemValue, child) {
                                    return Opacity(
                                      opacity: itemValue,
                                      child: Transform.translate(
                                        offset: Offset(0, 12 * (1 - itemValue)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: PokemonListItem(
                                    id: item.id,
                                    name: item.name,
                                    category: item.category,
                                    primaryType: item.primaryType,
                                    rating: item.rating,
                                    imageUrl: item.imageUrl,
                                    heroTag: 'pokemon-${item.id}',
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => PokemonDetailScreen(
                                            name: item.name,
                                            detailUrl: item.detailUrl,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PokemonCardData {
  const _PokemonCardData({
    required this.id,
    required this.name,
    required this.detailUrl,
    required this.primaryType,
    required this.category,
    required this.rating,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String detailUrl;
  final String primaryType;
  final String category;
  final double rating;
  final String imageUrl;
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No Pokémon found.',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF6B7280),
            ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded, size: 52, color: Color(0xFFE53935)),
            const SizedBox(height: 12),
            Text(
              'Unable to load Pokémon.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7280),
                  ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }
}

const List<String> _categoryOptions = <String>[
  'All',
  'Special',
  'Rare',
  'Legendary',
  'Common',
];