import 'package:pokedex/data/model/landing/pokemon_list_response.dart';
import 'package:pokedex/domain/mapper/landing/landing_mapper.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:test/test.dart';

import '../../mock/data_model.dart';

void main() {
  final mapper = LandingMapper();

  test(
      'map from PokemonListResponse to PokemonList, with hasNext as true when next value is not null',
      () {
    final output = mapper.mapPokemonList(pokemonListResponse);

    expect(output, equals(expectedOutputPokemonList));
  });

  test(
      'map from PokemonListResponse to PokemonList, when next is null,'
      ' hasNext should be false', () {
    PokemonListResponse pokemonListResponse = PokemonListResponse(
      results: [
        PokemonResponse(
          name: "bulbasaur",
          url: "https://pokeapi.co/api/v2/pokemon/1/",
        ),
        PokemonResponse(
          name: "ivysaur",
          url: "https://pokeapi.co/api/v2/pokemon/2",
        )
      ],
    );

    const expectedOutput = PokemonList(
      hasNext: false,
      pokemonList: [
        PokemonListItem(name: "bulbasaur", id: "1"),
        PokemonListItem(name: "ivysaur", id: "2")
      ],
    );
    final output = mapper.mapPokemonList(pokemonListResponse);

    expect(output, equals(expectedOutput));
  });

  test('map from PokemonDetailsResponse to PokemonDetail', () {
    final output = mapper.mapPokemonDetail(pokemonDetailResponse);

    expect(output, equals(expectedPokemonDetail));
  });

  test('if API return null value, will return [] as default value', () {
    final pokemonListResponse = PokemonListResponse();
    final output = mapper.mapPokemonList(pokemonListResponse);

    expect(output, equals(const PokemonList(hasNext: false, pokemonList: [])));
  });
}
