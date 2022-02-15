import 'package:injectable/injectable.dart';
import 'package:pokedex/common/network/base_network_repository.dart';
import 'package:pokedex/data/service/landing/landing_services.dart';
import 'package:pokedex/domain/mapper/landing/landing_mapper.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';

abstract class LandingRepository {
  Future<PokemonList> getPokemonList(int offset, int limit, bool isRefresh);

  Future<PokemonDetail> getPokemonDetail(String id);
}

@Singleton(as: LandingRepository)
class LandingRepositoryImpl extends BaseNetworkRepository
    implements LandingRepository {
  late final LandingService _landingService;
  late final LandingMapper _landingMapper;

  Map<String, PokemonDetail>? cachedPokemonDetail = {};

  LandingRepositoryImpl(this._landingMapper, this._landingService);

  @override
  Future<PokemonList> getPokemonList(int offset, int limit, bool isRefresh) async {
    // Clear cache
    if (isRefresh) {
      cachedPokemonDetail = null;
    }

    final response = await handle(() {
      return _landingService.getPokemonList(offset, limit);
    });

    return _landingMapper.mapPokemonListItem(response);
  }

  @override
  Future<PokemonDetail> getPokemonDetail(String id) async {
    // If user load this pokemon before, return cached data
    if (cachedPokemonDetail?[id] != null) {
      return cachedPokemonDetail![id]!;
    }

    final response = await handle(() {
      return _landingService.getPokemonDetail(id);
    });

    final transformedData = _landingMapper.mapPokemonDetail(response);
    // Cache pokemon detail
    cachedPokemonDetail?[id] = transformedData;

    return transformedData;
  }
}
