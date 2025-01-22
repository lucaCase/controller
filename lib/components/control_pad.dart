import 'package:controller/components/control_pad_button.dart';
import 'package:flutter/material.dart';

class ControlPad extends StatelessWidget {
  const ControlPad({super.key, required this.up, required this.down, required this.left, required this.right});

  final VoidCallback up;
  final VoidCallback down;
  final VoidCallback left;
  final VoidCallback right;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            ControlPadButton(onPressed: left, icon: Icons.arrow_back),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
        Column(
          children: [
            ControlPadButton(onPressed: up, icon: Icons.arrow_upward),
            const SizedBox(
              height: 25,
            ),
            ControlPadButton(onPressed: down, icon: Icons.arrow_downward),
          ],
        ),
        Column(
          children: [
            const SizedBox(
              height: 25,
            ),
            ControlPadButton(onPressed: right, icon: Icons.arrow_forward),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ],
    );
  }
}
