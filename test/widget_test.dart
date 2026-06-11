// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pokemon_app/models/pokemon_model.dart';
import 'package:pokemon_app/screens/home_screen.dart';
import 'package:pokemon_app/services/pokemon_service.dart';

void main() {
  testWidgets('renders and filters the modern Pokémon home screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(service: FakePokemonService()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
        (widget) => widget is Image && widget.image is AssetImage,
      ),
      findsOneWidget,
    );
    expect(find.text('Search Pokémon...'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Charizard'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'pika');
    await tester.pump();

    expect(find.text('Pikachu'), findsOneWidget);
    expect(find.text('Charizard'), findsNothing);
  });
}

class FakePokemonService extends PokemonService {
  @override
  Future<List<PokemonSummary>> fetchPokemonList() async {
    return const [
      PokemonSummary(
        name: 'charizard',
        url: 'https://pokeapi.co/api/v2/pokemon/6/',
      ),
      PokemonSummary(
        name: 'pikachu',
        url: 'https://pokeapi.co/api/v2/pokemon/25/',
      ),
    ];
  }

  @override
  Future<PokemonDetail> fetchPokemonDetail(String url) async {
    if (url.contains('/6/')) {
      return const PokemonDetail(
        name: 'charizard',
        imageUrl: '',
        height: 17,
        weight: 905,
        types: [PokemonTypeSlot(name: 'fire')],
      );
    }

    return const PokemonDetail(
      name: 'pikachu',
      imageUrl: '',
      height: 4,
      weight: 60,
      types: [PokemonTypeSlot(name: 'electric')],
    );
  }
}
