import 'package:controller/dto/value_holder.dart';
import 'package:vibration/vibration.dart';

class ResponseService {
  ValueHolder getValueHolderFromString(String valueHolder) {
    List<String> parts = valueHolder.split(":");
    if (parts.length == 1) {
      return ValueHolder(execute: fromString(parts[0], ""));
    } else {
      return ValueHolder(execute: fromString(parts[0], parts[1]));
    }
  }

  static Function fromString(String str, String value) {
    print(str);
    switch(str.toLowerCase()) {
      case "vibrate":
        return () {
          Vibration.vibrate(duration: int.parse(value));
        };
      default:
        throw Exception("Operation not supported");
    }
  }
}