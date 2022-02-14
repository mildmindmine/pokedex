import 'package:pokedex/data/model/detail_section/pokemon_details_response.dart';
import 'package:pokedex/data/model/landing/pokemon_list_response.dart';
import 'package:pokedex/domain/mapper/landing/landing_mapper.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:test/test.dart';

void main() {
  final mapper = LandingMapper();

  test('map from PokemonListResponse to List<PokemonListItem>', () {
    final pokemonListResponse = PokemonListResponse(results: [
      Pokemon(name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"),
      Pokemon(name: "ivysaur", url: "https://pokeapi.co/api/v2/pokemon/2")
    ]);
    const expectedOutput = [
      PokemonListItem(name: "bulbasaur", id: "1"),
      PokemonListItem(name: "ivysaur", id: "2")
    ];
    final output = mapper.mapPokemonListItem(pokemonListResponse);

    expect(output, equals(expectedOutput));
  });

  test('map from PokemonDetailsResponse to PokemonDetail', () {
    final response = PokemonDetailsResponse(
        name: "name",
        height: 10,
        weight: 20,
        sprites: Sprites(front_default: "url1", back_default: "url2"));
    const expectedResult = PokemonDetail(
      name: "name",
      frontImgUrl: "url1",
      backImgUrl: "url2",
      weight: 20,
      height: 10,
    );

    final output = mapper.mapPokemonDetail(response);

    expect(output, equals(expectedResult));
  });

  test('if API return null value, will return [] as default value', () {
    final pokemonListResponse = PokemonListResponse();
    final output = mapper.mapPokemonListItem(pokemonListResponse);

    expect(output, equals([]));
  });
}
