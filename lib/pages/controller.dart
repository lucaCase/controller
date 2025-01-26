import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rotation_sensor/flutter_rotation_sensor.dart';

import '../components/control_pad.dart';
import '../components/game_button.dart';
import '../components/pause_button.dart';
import '../dto/input.dart';
import '../dto/sensor_data.dart';
import '../dto/server.dart';
import '../services/state_service.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors_plus;

import '../services/udp_service.dart';

class Controller extends StatefulWidget {
  const Controller({super.key});

  @override
  State<Controller> createState() => _ControllerState();
}

class _ControllerState extends State<Controller> {
  bool shouldSendSensorData = false;

  double roll = 0;
  double pitch = 0;
  double yaw = 0;

  double xAcc = 0;
  double yAcc = 0;
  double zAcc = 0;

  Server? server;
  late UdpService udpService;

  @override
  void initState() {
    super.initState();

    udpService = UdpService((bool value) {
      setState(() {
        shouldSendSensorData = value;
      });
    });

    RotationSensor.orientationStream.listen((event) {
      roll = event.eulerAngles.roll;
      pitch = event.eulerAngles.pitch;
      yaw = event.eulerAngles.yaw;
    });

    sensors_plus.userAccelerometerEventStream().listen((event) {
      xAcc = event.x;
      yAcc = event.y;
      zAcc = event.z;
    });

    Timer.periodic(const Duration(milliseconds: 50), (timer) async {
      if (shouldSendSensorData) {
        UdpService.sendSensorData(
            SensorData(roll, pitch, yaw, xAcc, yAcc, zAcc), server!.ip, server!.port);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    server = server ?? ModalRoute.of(context)!.settings.arguments as Server;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PauseButton(
                      onPressed: (state) {
                        udpService.send(
                            StateService.getStatesAsMap(
                                Input.InputMinus, state),
                            server!.ip,
                            server!.port);
                      },
                      text: '-',
                    ),
                    PauseButton(
                      onPressed: (state) {
                        udpService.send(
                            StateService.getStatesAsMap(Input.InputPlus, state),
                            server!.ip,
                            server!.port);
                      },
                      text: '+',
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -75),
                child: ControlPad(
                  up: (state) {
                    udpService.send(
                        StateService.getStatesAsMap(Input.InputUp, state),
                        server!.ip,
                        server!.port);
                  },
                  down: (state) {
                    udpService.send(
                        StateService.getStatesAsMap(Input.InputDown, state),
                        server!.ip,
                        server!.port);
                  },
                  left: (state) {
                    udpService.send(
                        StateService.getStatesAsMap(Input.InputLeft, state),
                        server!.ip,
                        server!.port);
                  },
                  right: (state) {
                    udpService.send(
                        StateService.getStatesAsMap(Input.InputRight, state),
                        server!.ip,
                        server!.port);
                  },
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -75),
                child: GameButton(
                  onPressed: (state) async {
                    udpService.send(
                        StateService.getStatesAsMap(Input.InputA, state),
                        server!.ip,
                        server!.port);
                  },
                  text: 'A',
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -30),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GameButton(
                        onPressed: (state) {
                          udpService.send(
                              StateService.getStatesAsMap(Input.Input1, state),
                              server!.ip,
                              server!.port);
                        },
                        text: '1',
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GameButton(
                        onPressed: (state) {
                          udpService.send(
                              StateService.getStatesAsMap(Input.Input2, state),
                              server!.ip,
                              server!.port);
                        },
                        text: '2',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}