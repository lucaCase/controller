import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:controller/dto/input.dart';
import 'package:controller/dto/sensor_data.dart';
import 'package:controller/dto/value_holder.dart';
import 'package:controller/services/response_service.dart';
import 'package:flutter/cupertino.dart';

class UdpService {
  late ResponseService responseService = ResponseService((value) {
    shouldSendSensorData(value);
  },);

  ValueChanged<bool> shouldSendSensorData;

  UdpService({required this.shouldSendSensorData});

  static const utf8 = Utf8Codec();

  static InternetAddress address = InternetAddress("192.168.0.46");
  static const int port = 11000;

  Future<ValueHolder> send(Input input) async {
    String response = '';

    RawDatagramSocket socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4, 11000);

    socket.send(
        utf8.encode(input.name), address, port);

    Completer<String> completer = Completer<String>();
    socket.listen((event) {
      if (event == RawSocketEvent.read) {
        final datagram = socket.receive();
        if (datagram != null) {
          response = utf8.decode(datagram.data);
          completer.complete(response);
          socket.close();
        }
      }
    });

    return responseService.getValueHolderFromString(await completer.future);
  }

  static void sendSensorData(SensorData data) async {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 11000).then((socket) {
      socket.send(utf8.encode(data.toString()), address, port);
    });
  }
}