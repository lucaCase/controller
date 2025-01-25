import 'package:controller/dto/value_holder.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ResponseService {
  ValueChanged<bool> shouldSendSensorData;


  ResponseService(this.shouldSendSensorData);

  ValueHolder getValueHolderFromString(String valueHolder) {
    List<String> parts = valueHolder.split(":");
    if (parts.length == 1) {
      return ValueHolder(execute: fromString(parts[0], ""));
    } else {
      return ValueHolder(execute: fromString(parts[0], parts[1]));
    }
  }

  Function fromString(String str, String value) {
    print(str);
    switch(str) {
      case "Vibrate":
        return () {
          Vibration.vibrate(duration: int.parse(value));
        };
      case "StartSendSensorData":
        return () {
          shouldSendSensorData(true);
        };
      case "StopSendSensorData":
        return () {
          shouldSendSensorData(false);
        };
      default:
        throw Exception("Operation not supported");
    }
  }
}