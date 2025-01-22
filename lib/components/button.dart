import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      width: 75,
        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(100)),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(),
          child: Text(text),
        ));
  }
}
