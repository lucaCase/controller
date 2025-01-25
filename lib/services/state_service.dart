import 'package:controller/dto/input.dart';
import 'package:controller/dto/input_state.dart';

class StateService {
  static Map<Input, List<InputState>> getStatesAsMap(Input input, InputState state) {
    Map<Input, List<InputState>> inputStates = {};
    inputStates[input] = [];
    inputStates[input]?.add(state);

    return inputStates;
  }
}
