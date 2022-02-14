import 'package:json_annotation/json_annotation.dart';

part 'pokemon_details_response.g.dart';

@JsonSerializable()
class PokemonDetailsResponse {
  final int? height;
  final int? weight;
  final String? name;
  final Sprites? sprites;

  PokemonDetailsResponse({
    this.height,
    this.name,
    this.sprites,
    this.weight,
  });

  factory PokemonDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailsResponseFromJson(json);
}

@JsonSerializable()
class Sprites {
  final String? back_default;
  final String? front_default;

  Sprites({
    this.back_default,
    this.front_default,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) =>
      _$SpritesFromJson(json);
}
