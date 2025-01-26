import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:controller/dto/input_holder.dart';
import 'package:controller/dto/sensor_data.dart';
import 'package:controller/dto/value_holder.dart';
import 'package:controller/services/response_service.dart';
import 'package:flutter/cupertino.dart';

class UdpService {
  ValueChanged<bool>? shouldSendSensorData;


  UdpService(this.shouldSendSensorData);

  late ResponseService responseService = ResponseService((value) {
    shouldSendSensorData!(value);
  });

  static const utf8 = Utf8Codec();

  Future<ValueHolder> send(InputHolder holder, InternetAddress address, int port) async {
    String response = '';

    RawDatagramSocket socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4, port);

    socket.send(
        utf8.encode(holder.toString()), address, port);

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

    var method = responseService.getValueHolderFromString(await completer.future);
    method.execute();
    return method;
  }

  static void sendSensorData(SensorData data, InternetAddress address, int port) async {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, port).then((socket) {
      socket.send(utf8.encode(data.toString()), address, port);
    });
  }

  static Future<double> sendPing(InternetAddress address, int port) async {
    double time = 0;
    Stopwatch stopwatch = Stopwatch()..start();

    print("$address:$port");

    try {
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, port);
      socket.send(utf8.encode("Ping"), address, port);

      const timeout = Duration(seconds: 3);

      Completer<double> completer = Completer();
      Timer? timer;

      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            time = stopwatch.elapsedMilliseconds.toDouble();
            completer.complete(time);
            socket.close();
          }
        }
      });

      timer = Timer(timeout, () {
        if (!completer.isCompleted) {
          completer.complete(-1);
          socket.close();
        }
      });

      return await completer.future;
    } catch (e) {
      return -1;
    }
  }
}