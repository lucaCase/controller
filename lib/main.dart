import 'dart:async';
import 'package:controller/components/game_button.dart';
import 'package:controller/components/control_pad.dart';
import 'package:controller/dto/sensor_data.dart';
import 'package:controller/dto/value_holder.dart';
import 'package:controller/services/state_service.dart';
import 'package:controller/services/udp_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rotation_sensor/flutter_rotation_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors_plus;

import 'components/pause_button.dart';
import 'dto/input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String echo = '';

  bool shouldSendSensorData = false;

  double roll = 0;
  double pitch = 0;
  double yaw = 0;

  double xAcc = 0;
  double yAcc = 0;
  double zAcc = 0;

  late UdpService udp = UdpService(shouldSendSensorData: (bool value) {
    shouldSendSensorData = value;
  });

  @override
  void initState() {
    super.initState();

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
            SensorData(roll, pitch, yaw, xAcc, yAcc, zAcc));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
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
                          print(StateService.getStatesAsMap(
                              Input.pauseLeft, state));
                        },
                        text: '-',
                      ),
                      PauseButton(
                        onPressed: (state) {},
                        text: '+',
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -75),
                  child: ControlPad(
                    up: (state) {
                      print(StateService.getStatesAsMap(Input.keyUp, state));
                    },
                    down: (state) {
                      print(StateService.getStatesAsMap(Input.keyDown, state));
                    },
                    left: (state) {
                      print(StateService.getStatesAsMap(Input.keyLeft, state));

                    },
                    right: (state) {
                      print(StateService.getStatesAsMap(Input.keyRight, state));

                    },
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -75),
                  child: GameButton(
                    onPressed: (state) async {
                      ValueHolder sensorData = await udp.send(Input.keyA);

                      setState(() {
                        sensorData.execute();
                      });
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
                            print(StateService.getStatesAsMap(Input.key1, state));
                          },
                          text: '1',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GameButton(
                          onPressed: (state) {
                            print(StateService.getStatesAsMap(Input.key2, state));
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
      ),
    );
  }
}
