class PokemonSummary {
  const PokemonSummary({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory PokemonSummary.fromJson(Map<String, dynamic> json) {
    return PokemonSummary(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

class PokemonListResponse {
  const PokemonListResponse({
    required this.count,
    required this.next,
    required this.previous,
    required this.results,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<PokemonSummary> results;

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>? ?? const [])
          .map((item) => PokemonSummary.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PokemonTypeSlot {
  const PokemonTypeSlot({required this.name});

  final String name;

  factory PokemonTypeSlot.fromJson(Map<String, dynamic> json) {
    return PokemonTypeSlot(
      name: (json['type'] as Map<String, dynamic>?)?['name'] as String? ?? '',
    );
  }
}

class PokemonDetail {
  const PokemonDetail({
    required this.name,
    required this.imageUrl,
    required this.height,
    required this.weight,
    required this.types,
  });

  final String name;
  final String imageUrl;
  final int height;
  final int weight;
  final List<PokemonTypeSlot> types;

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>? ?? const {};
    final other = sprites['other'] as Map<String, dynamic>? ?? const {};
    final officialArtwork = other['official-artwork'] as Map<String, dynamic>? ?? const {};

    return PokemonDetail(
      name: json['name'] as String? ?? '',
      imageUrl: officialArtwork['front_default'] as String? ?? '',
      height: json['height'] as int? ?? 0,
      weight: json['weight'] as int? ?? 0,
      types: (json['types'] as List<dynamic>? ?? const [])
          .map((item) => PokemonTypeSlot.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}