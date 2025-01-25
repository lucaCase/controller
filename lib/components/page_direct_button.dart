import 'package:flutter/material.dart';

class PageDirectButton extends StatelessWidget {
  const PageDirectButton({super.key, required this.title, required this.route});

  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
