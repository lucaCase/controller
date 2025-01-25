import 'package:controller/components/sized_button.dart';
import 'package:flutter/material.dart';

import '../dto/input_state.dart';

class ControlPadButton extends StatelessWidget {
  const ControlPadButton({super.key, required this.onPressed, required this.icon});

  final ValueChanged<InputState> onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedButton(onPressed: onPressed, metric: 75, child: Icon(icon));

  }
}
