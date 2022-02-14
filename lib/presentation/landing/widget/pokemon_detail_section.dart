import 'package:flutter/material.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/utils/extension/generic_extension.dart';

class PokemonDetailSection extends StatefulWidget {
  final PokemonDetail? detail;
  final bool isLoading;

  const PokemonDetailSection({
    Key? key,
    this.detail,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<PokemonDetailSection> createState() => _PokemonDetailSectionState();
}

class _PokemonDetailSectionState extends State<PokemonDetailSection> {
  bool _loadingFrontImg = true;
  bool _loadingBackImg = true;

  Widget _buildLoadingSection() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildTextWithBoldResult(
      BuildContext context, String? value, String title) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: DefaultTextStyle.of(context).style,
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCannotLoad() {
    return const Icon(
      Icons.error,
      size: 40,
    );
  }

  Widget _buildPokemonInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            (widget.detail?.name).safeUnwrapped(),
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      (widget.detail?.frontImgUrl).safeUnwrapped(),
                      fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImageCannotLoad(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      (widget.detail?.backImgUrl).safeUnwrapped(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildImageCannotLoad(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextWithBoldResult(
                context,
                widget.detail?.weight.toString(),
                "Weight",
              ),
              const SizedBox(
                width: 16,
              ),
              _buildTextWithBoldResult(
                context,
                widget.detail?.height.toString(),
                "Height",
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(context),
          if (widget.detail == null) _buildLoadingSection(),
          if (widget.detail != null) _buildPokemonInfo(context)
        ],
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.25,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12.0,
        ),
        child: Container(
          height: 3.0,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(2.5)),
          ),
        ),
      ),
    );
  }
}
