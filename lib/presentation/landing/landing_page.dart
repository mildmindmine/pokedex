import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/presentation/landing/landing_page_view_model.dart';
import 'package:pokedex/presentation/landing/widget/empty_page.dart';
import 'package:pokedex/presentation/landing/widget/loading_section.dart';
import 'package:pokedex/presentation/landing/widget/pokemon_detail_section.dart';
import 'package:pokedex/utils/dialogs.dart';
import 'package:rxdart/rxdart.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({
    Key? key,
  }) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  final LandingPageViewModel _viewModel = GetIt.I<LandingPageViewModel>();

  // Variable
  bool _isLoading = false;
  bool _hasNext = true;
  late final Animation<double> _animation;

  // Controllers
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  @override
  void initState() {
    _setAnimationController();
    _subscribeToViewModel();
    _handleInfiniteLoad();

    _viewModel.getPokemonList();
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
    /// Fetch new list when user scroll to the end of listview
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
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

    _viewModel.hasNext.listen((hasNext) {
      setState(() {
        _hasNext = hasNext;
      });
    }).addTo(_viewModel.compositeSubscription);
  }

  int _checkScrollContent(int displayListLength) {
    if (_hasNext) {
      // If has more to fetch will be adding loading section at the end of the list
      return displayListLength + 1;
    }

    return displayListLength;
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
                    if (index == displayList.length) {
                      return const LoadingSection();
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
              child: _isLoading ? const LoadingSection() : const EmptyPage(),
            );
          },
        ),
      ),
    );
  }
}
