import 'package:controller/components/sized_button.dart';
import 'package:controller/dto/input_state.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  const PauseButton({super.key, required this.onPressed, required this.text});

  final ValueChanged<InputState> onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedButton(metric: 35, onPressed: onPressed, child: Text(text));
  }
}