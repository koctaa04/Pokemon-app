import 'package:flutter/material.dart';

import '../models/pokemon_model.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_info_chip.dart';

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

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  final PokemonService _service = PokemonService();
  late final Future<PokemonDetail> _pokemonFuture;

  @override
  void initState() {
    super.initState();
    _pokemonFuture = _service.fetchPokemonDetail(widget.detailUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: FutureBuilder<PokemonDetail>(
        future: _pokemonFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to load Pokémon details.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final pokemon = snapshot.data;

          if (pokemon == null) {
            return const Center(child: Text('No Pokémon detail available.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: pokemon.imageUrl.isEmpty
                            ? const Icon(Icons.catching_pokemon, size: 120)
                            : Image.network(
                                pokemon.imageUrl,
                                fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                  Icons.catching_pokemon,
                                  size: 120,
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        pokemon.name.toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: PokemonInfoChip(
                        label: 'Height',
                        value: pokemon.height.toString(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PokemonInfoChip(
                        label: 'Weight',
                        value: pokemon.weight.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Types',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: pokemon.types
                      .map(
                        (type) => Chip(
                          label: Text(type.name),
                          backgroundColor: const Color(0xFFFFF4E5),
                          side: BorderSide.none,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}