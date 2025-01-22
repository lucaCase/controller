import 'package:flutter/material.dart';

class ControlPadButton extends StatelessWidget {
  const ControlPadButton({super.key, required this.onPressed, required this.icon});

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 75,
        width: 75,
        decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(100)),
        child: IconButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(),
          icon: Icon(icon),
        ));
  }
}
