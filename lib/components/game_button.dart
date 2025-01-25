import 'package:controller/components/sized_button.dart';
import 'package:controller/dto/input_state.dart';
import 'package:flutter/material.dart';

class GameButton extends StatelessWidget {
  const GameButton({super.key, required this.onPressed, required this.text});

  final ValueChanged<InputState> onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedButton(metric: 75, onPressed: onPressed, child: Text(text));
  }
}
