import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:controller/dto/input.dart';
import 'package:controller/dto/value_holder.dart';
import 'package:controller/services/response_service.dart';
import 'package:flutter/cupertino.dart';

class UdpService {
  ResponseService responseService = ResponseService();

  ValueChanged<bool> shouldSendSensorData;


  UdpService({required this.shouldSendSensorData});

  static const utf8 = Utf8Codec();

  Future<ValueHolder> send(Input input) async {
    String response = '';

    RawDatagramSocket socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 11000);

    socket.send(utf8.encode(input.name), InternetAddress("192.168.0.46"), 11000);

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
}