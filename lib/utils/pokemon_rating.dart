double pokemonRatingForId(int id) {
  final normalized = (id * 37) % 11;
  final rating = 4.0 + (normalized / 10.0);
  return double.parse(rating.clamp(4.0, 5.0).toStringAsFixed(1));
}