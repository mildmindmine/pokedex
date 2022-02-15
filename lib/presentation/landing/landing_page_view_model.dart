import 'package:injectable/injectable.dart';
import 'package:pokedex/common/constants.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_detail_use_case.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_list_use_case.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class LandingPageViewModel {
  final CompositeSubscription compositeSubscription = CompositeSubscription();
  final GetPokemonDetailUseCase _getPokemonDetailUseCase;
  final GetPokemonListUseCase _getPokemonListUseCase;

  final BehaviorSubject<List<PokemonListItem>?> _pokemonList =
      BehaviorSubject();
  final BehaviorSubject<PokemonDetail?> _pokemonDetail = BehaviorSubject();
  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<bool> _hasNext = BehaviorSubject();
  final PublishSubject<String> _showError = PublishSubject();
  final PublishSubject<Object?> _openPokemonDetailSection = PublishSubject();

  Stream<List<PokemonListItem>?> get pokemonList => _pokemonList;

  Stream<PokemonDetail?> get pokemonDetail => _pokemonDetail;

  Stream<bool> get isLoading => _isLoading;

  Stream<String> get showError => _showError;

  Stream<Object?> get openPokemonDetailSection => _openPokemonDetailSection;

  Stream<bool> get hasNext => _hasNext;

  /// Initial values
  int _offset = AppConstant.initialOffset;
  final int _limit = AppConstant.initialLimit;

  LandingPageViewModel(
    this._getPokemonDetailUseCase,
    this._getPokemonListUseCase,
  );

  void onListTileTapped(String id) {
    getPokemonDetail(id);
    _openPokemonDetailSection.add(null);
  }

  void onDispose() {
    compositeSubscription.dispose();
  }

  void clearDisplayedPokemonDetail() {
    _pokemonDetail.add(null);
  }

  void _refreshToInitialValue() {
    _pokemonList.add(null);
    _offset = AppConstant.initialOffset;
  }

  void getPokemonList([isRefresh = false]) async {
    /// If it's refresh, reset variable to initial value
    /// else no next, stop fetching if there is no next data list
    if (isRefresh) {
      _refreshToInitialValue();
    } else if (_hasNext.valueOrNull == false) {
      return;
    }

    _isLoading.add(true);

    final result = await _getPokemonListUseCase.getPokemonList(
      _offset,
      _limit,
      isRefresh,
    );

    _isLoading.add(false);

    result.when(success: (PokemonList data) {
      final prevData = _pokemonList.valueOrNull ?? [];
      prevData.addAll(data.pokemonList);
      _pokemonList.value = prevData;
      _offset += _limit;
      _hasNext.add(data.hasNext);
    }, genericFailure: (failure) {
      _showError.add(failure.toString());
    }, serverFailure: (failure) {
      _showError.add(failure.description);
    });
  }

  void getPokemonDetail(String id) async {
    _isLoading.add(true);

    final result = await _getPokemonDetailUseCase.getPokemonDetail(id);

    _isLoading.add(false);

    result.when(success: (PokemonDetail data) {
      _pokemonDetail.add(data);
    }, genericFailure: (failure) {
      _showError.add(failure.toString());
    }, serverFailure: (failure) {
      _showError.add(failure.description);
    });
  }
}
