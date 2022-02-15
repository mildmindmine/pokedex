import 'package:flutter/material.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_detail_use_case.dart';
import 'package:pokedex/domain/use_case/landing/get_pokemon_list_use_case.dart';
import 'package:pokedex/presentation/landing/landing_page_view_model.dart';
import 'package:pokedex/presentation/landing/widget/empty_page.dart';
import 'package:pokedex/presentation/landing/widget/pokemon_detail_section.dart';
import 'package:pokedex/utils/dialogs.dart';
import 'package:rxdart/rxdart.dart';

class LandingPage extends StatefulWidget {
  final GetPokemonListUseCase? getPokemonListUseCase;
  final GetPokemonDetailUseCase? getPokemonDetailUseCase;

  const LandingPage({
    Key? key,
    this.getPokemonListUseCase,
    this.getPokemonDetailUseCase,
  }) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late final LandingPageViewModel _viewModel;

  // Variable
  bool _isLoading = false;
  late final Animation<double> _animation;

  // Controllers
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  @override
  void initState() {
    _viewModel = LandingPageViewModel(
      getPokemonDetailUseCase: widget.getPokemonDetailUseCase,
      getPokemonListUseCase: widget.getPokemonListUseCase,
    );
    _setAnimationController();
    _subscribeToViewModel();
    _viewModel.getPokemonList(true);
    _handleInfiniteLoad();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.onDispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _setAnimationController() {
    _animationController = BottomSheet.createAnimationController(this);
    _animationController.duration = const Duration(milliseconds: 300);
    _animationController.reverseDuration = const Duration(milliseconds: 200);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _handleInfiniteLoad() {
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    /// Fetch new list when user scroll to 90% of listview height
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent * 0.9) {
      _viewModel.getPokemonList();
    }
  }

  void _subscribeToViewModel() {
    _viewModel.isLoading.listen((isLoading) {
      setState(() {
        _isLoading = isLoading;
      });
    }).addTo(_viewModel.compositeSubscription);

    _viewModel.showError.listen((error) {
      Dialogs.genericAlertDialog(
          context: context,
          title: "API Error",
          message: error,
          onPositiveButtonPressed: () {
            // Pop bottom sheet too if it's open
            Navigator.popUntil(context, (route) => route.isFirst);
          });
    }).addTo(_viewModel.compositeSubscription);

    _viewModel.openPokemonDetailSection.listen((event) {
      showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        transitionAnimationController: _animationController,
        context: context,
        builder: (context) {
          return StreamBuilder(
            stream: _viewModel.pokemonDetail,
            builder: (BuildContext context, snapshot) {
              return PokemonDetailSection(
                detail: snapshot.data as PokemonDetail?,
                animation: _animation,
              );
            },
          );
        },
      );
    }).addTo(_viewModel.compositeSubscription);
  }

  Widget _buildLoadingSection() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// If listview height is less than 90% of the screen, will display loading
  /// section at the bottom of the list when fetching
  int _checkScrollContent(int displayListLength) {
    if (_scrollController.positions.isNotEmpty &&
        _scrollController.position.maxScrollExtent <
            MediaQuery.of(context).size.height * 0.9) {
      return displayListLength;
    }
    return displayListLength + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokedex"),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _viewModel.pokemonList,
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData && snapshot.data != []) {
              final displayList = snapshot.data as List<PokemonListItem>;
              return RefreshIndicator(
                onRefresh: () async => _viewModel.getPokemonList(true),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  itemCount: _checkScrollContent(displayList.length),
                  itemBuilder: (context, index) {
                    /// Return loading indicator section when it start to load
                    if (index >= displayList.length) {
                      return _isLoading ? _buildLoadingSection() : Container();
                    }

                    /// Build pokemon list item
                    return ListTile(
                      onTap: () {
                        _viewModel.clearDisplayedPokemonDetail();
                        _viewModel.onListTileTapped(displayList[index].id);
                      },
                      title: Text(displayList[index].name),
                    );
                  },
                ),
              );
            }

            return SizedBox.expand(
              child: _isLoading ? _buildLoadingSection() : const EmptyPage(),
            );
          },
        ),
      ),
    );
  }
}
