import 'package:pokedex/data/model/detail_section/pokemon_details_response.dart';
import 'package:pokedex/data/model/landing/pokemon_list_response.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';

const expectedPokemonDetail = PokemonDetail(
  name: "name",
  frontImgUrl:
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
  backImgUrl:
      "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
  weight: 10,
  height: 10,
);

final pokemonDetailResponse = PokemonDetailsResponse(
  name: "name",
  height: 10,
  weight: 10,
  sprites: Sprites(
    front_default:
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png",
    back_default:
        "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/back/1.png",
  ),
);

PokemonListResponse pokemonListResponse = PokemonListResponse(
  next: "some url",
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

const expectedOutputPokemonList = PokemonList(
  hasNext: true,
  pokemonList: [
    PokemonListItem(name: "bulbasaur", id: "1"),
    PokemonListItem(name: "ivysaur", id: "2")
  ],
);

const expectedOutputPokemonListHasNextIsFalse = PokemonList(
  hasNext: false,
  pokemonList: [
    PokemonListItem(name: "bulbasaur", id: "1"),
    PokemonListItem(name: "ivysaur", id: "2")
  ],
);
