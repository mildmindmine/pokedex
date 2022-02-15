import 'package:flutter/material.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/domain/model/landing/pokemon_list_item.dart';
import 'package:pokedex/presentation/landing/landing_page_view_model.dart';
import 'package:pokedex/presentation/landing/widget/empty_page.dart';
import 'package:pokedex/presentation/landing/widget/pokemon_detail_section.dart';
import 'package:pokedex/utils/dialogs.dart';
import 'package:rxdart/rxdart.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final LandingPageViewModel _viewModel = LandingPageViewModel();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    _subscribeToViewModel();
    _viewModel.getPokemonList(true);
    _handleInfiniteLoad();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.onDispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleInfiniteLoad() {
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
        context: context,
        builder: (context) {
          return StreamBuilder(
            stream: _viewModel.pokemonDetail,
            builder: (BuildContext context, snapshot) {
              return PokemonDetailSection(
                detail: snapshot.data as PokemonDetail?,
              );
            },
          );
        },
      ).then((value) => _viewModel.clearDisplayedPokemonDetail());
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
                  itemCount: displayList.length + 1,
                  itemBuilder: (context, index) {
                    /// Return loading indicator section when it start to load
                    if (index >= displayList.length) {
                      return _isLoading ? Container() : _buildLoadingSection();
                    }

                    /// Build pokemon list item
                    return ListTile(
                      onTap: () {
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
