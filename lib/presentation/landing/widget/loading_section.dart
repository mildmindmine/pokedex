import 'package:flutter/material.dart';

class LoadingSection extends StatelessWidget {
  const LoadingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
