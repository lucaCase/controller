import 'package:controller/dto/input_state.dart';
import 'package:flutter/material.dart';

class SizedButton extends StatelessWidget {
  SizedButton({
    super.key,
    required this.onPressed,
    required this.child,
    required this.metric,
  });

  final ValueChanged<InputState> onPressed;
  final Widget child;
  final double metric;

  bool wasPressedLong = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onPressed(InputState.Pressed);
        wasPressedLong = true;
      },
      child: Listener(
        onPointerUp: (_) {
          if (wasPressedLong) {
            onPressed(InputState.Up);
            wasPressedLong = false;
            onPressed(InputState.None);
          }
        },
        onPointerDown: (_) => onPressed(InputState.Down),
        child: Container(
          height: metric,
          width: metric,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: child
        ),
      ),
    );
  }
}
