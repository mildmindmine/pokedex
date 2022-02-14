import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.import_contacts,
          size: 50,
          color: Colors.grey,
        ),
        Text(
          "Sorry, the list is empty",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
