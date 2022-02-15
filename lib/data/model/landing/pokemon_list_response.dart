import 'package:json_annotation/json_annotation.dart';

part 'pokemon_list_response.g.dart';

@JsonSerializable()
class PokemonListResponse {
  final String? next;
  final List<PokemonResponse>? results;

  PokemonListResponse({this.next, this.results});

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);
}

@JsonSerializable()
class PokemonResponse {
  final String? name;
  final String? url;

  PokemonResponse({
    this.name,
    this.url,
  });

  factory PokemonResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonResponseFromJson(json);
}
