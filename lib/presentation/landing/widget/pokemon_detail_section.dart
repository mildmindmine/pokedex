import 'package:flutter/material.dart';
import 'package:pokedex/domain/model/detail_section/pokemon_detail.dart';
import 'package:pokedex/presentation/landing/widget/loading_section.dart';
import 'package:pokedex/utils/extension/generic_extension.dart';

class PokemonDetailSection extends StatelessWidget {
  final PokemonDetail? detail;
  final Animation<double> animation;

  const PokemonDetailSection({
    Key? key,
    this.detail,
    required this.animation,
  }) : super(key: key);

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

  Widget _buildImage(BuildContext context, String url) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildImageCannotLoad(),
        ),
      ),
    );
  }

  Widget _buildPokemonInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            (detail?.name).safeUnwrapped(),
            style: Theme.of(context).textTheme.headline5,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildImage(context, (detail?.frontImgUrl).safeUnwrapped()),
                _buildImage(context, (detail?.backImgUrl).safeUnwrapped())
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextWithBoldResult(
                context,
                detail?.weight.toString(),
                "Weight",
              ),
              const SizedBox(
                width: 16,
              ),
              _buildTextWithBoldResult(
                context,
                detail?.height.toString(),
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
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.fastOutSlowIn,
          child: FadeTransition(
            opacity: animation,
            child: Column(
              children: [
                _buildHandle(context),
                detail == null
                    ? const LoadingSection()
                    : _buildPokemonInfo(context),
              ],
            ),
          ),
        ),
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
