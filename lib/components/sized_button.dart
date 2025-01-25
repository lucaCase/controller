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
        onPressed(InputState.pressed);
        wasPressedLong = true;
      },
      child: Listener(
        onPointerUp: (_) {
          if (wasPressedLong) {
            onPressed(InputState.up);
            wasPressedLong = false;
            onPressed(InputState.none);
          }
        },
        onPointerDown: (_) => onPressed(InputState.down),
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
