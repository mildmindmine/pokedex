import 'package:dio/dio.dart';
import 'package:pokedex/common/constants.dart';
import 'package:pokedex/data/model/detail_section/pokemon_details_response.dart';
import 'package:pokedex/data/model/landing/pokemon_list_response.dart';
import 'package:retrofit/http.dart';

part 'landing_services.g.dart';

@RestApi(baseUrl: AppConstant.baseUrl)
abstract class LandingService {
  factory LandingService(Dio dio, {String baseUrl}) = _LandingService;

  @GET('/v2/pokemon')
  Future<PokemonListResponse> getPokemonList(
    @Query("offset") int offset,
    @Query("limit") int limit,
  );

  @GET('/v2/pokemon/{id}')
  Future<PokemonDetailsResponse> getPokemonDetail(
    @Path("id") String id,
  );
}
