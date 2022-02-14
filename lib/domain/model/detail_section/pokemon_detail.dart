import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail.freezed.dart';

@freezed
class PokemonDetail with _$PokemonDetail {
  const factory PokemonDetail({
    required String name,
    required String frontImgUrl,
    required String backImgUrl,
    required int weight,
    required int height,
  }) = _PokemonDetail;
}
