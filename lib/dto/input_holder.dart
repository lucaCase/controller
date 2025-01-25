import 'package:controller/dto/input.dart';
import 'package:controller/dto/input_state.dart';

class InputHolder {
  Map<Input, InputState> input = {};

  InputHolder(this.input);

  @override
  String toString() {
    return "${input.keys.first.name}:${input.values.first.name}";
  }
}