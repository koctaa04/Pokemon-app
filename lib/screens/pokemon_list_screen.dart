import 'package:flutter/material.dart';

import '../models/pokemon_model.dart';
import '../services/pokemon_service.dart';
import '../widgets/pokemon_list_item.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});

  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  final PokemonService _service = PokemonService();
  late final Future<List<PokemonSummary>> _pokemonFuture = _service.fetchPokemonList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon List'),
      ),
      body: FutureBuilder<List<PokemonSummary>>(
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
                  'Unable to load Pokémon.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final pokemon = snapshot.data ?? const <PokemonSummary>[];

          if (pokemon.isEmpty) {
            return const Center(child: Text('No Pokémon found.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pokemon.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = pokemon[index];

              return PokemonListItem(
                pokemon: item,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PokemonDetailScreen(
                        name: item.name,
                        detailUrl: item.url,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}