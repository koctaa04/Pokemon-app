import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/pokemon_model.dart';

class PokemonService {
  PokemonService({http.Client? client}) : _client = client ?? http.Client();

  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon/';

  final http.Client _client;

  Future<List<PokemonSummary>> fetchPokemonList() async {
    final response = await _client.get(Uri.parse(_baseUrl));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokémon list.');
    }

    final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
    return PokemonListResponse.fromJson(data).results;
  }

  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    final response = await _client.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load Pokémon details.');
    }

    final Map<String, dynamic> data = jsonDecode(response.body) as Map<String, dynamic>;
    return PokemonDetail.fromJson(data);
  }
}