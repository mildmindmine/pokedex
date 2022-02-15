import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_item.freezed.dart';

@freezed
class PokemonList with _$PokemonList {
  const factory PokemonList({
    required bool hasNext,
    required List<PokemonListItem> pokemonList,
  }) = _PokemonList;
}

@freezed
class PokemonListItem with _$PokemonListItem {
  const factory PokemonListItem({
    required String name,
    required String id,
  }) = _PokemonListItem;
}
