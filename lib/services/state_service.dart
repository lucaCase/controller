import 'package:controller/dto/input.dart';
import 'package:controller/dto/input_holder.dart';
import 'package:controller/dto/input_state.dart';

class StateService {
  static InputHolder getStatesAsMap(Input input, InputState state) {
    Map<Input, InputState> inputStates = {};
    inputStates[input] = state;

    return InputHolder(inputStates);
  }
}
