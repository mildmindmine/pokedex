import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as path;
import 'package:pokedex/data/model/detail_section/pokemon_details_response.dart';
import 'package:pokedex/data/model/landing/pokemon_list_response.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/utils/extension/generic_extension.dart';

@injectable
class LandingMapper {
  PokemonList mapPokemonList(PokemonListResponse response) {
    final pokemonList = response.results?.map((pokemon) {
          assert(pokemon.name != null, 'pokemon name should not be null');
          assert(pokemon.url != null, 'pokemon url should not be null');

          // Extract id from URL
          final String pokemonId = path.basename(pokemon.url as String);

          return PokemonListItem(
            name: pokemon.name.safeUnwrapped(),
            id: pokemonId,
          );
        }).toList() ??
        []; // If the value come as null, default will be empty list

    return PokemonList(
      hasNext: response.next != null,
      pokemonList: pokemonList,
    );
  }

  PokemonDetail mapPokemonDetail(PokemonDetailsResponse response) {
    return PokemonDetail(
      name: response.name.safeUnwrapped(),
      frontImgUrl: (response.sprites?.front_default).safeUnwrapped(),
      backImgUrl: (response.sprites?.back_default).safeUnwrapped(),
      weight: response.weight.safeUnwrapped(),
      height: response.height.safeUnwrapped(),
    );
  }
}
