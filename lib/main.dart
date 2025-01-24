import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:all_sensors/all_sensors.dart';
import 'package:controller/components/button.dart';
import 'package:controller/components/control_pad.dart';
import 'package:controller/dto/value_holder.dart';
import 'package:controller/services/udp_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rotation_sensor/flutter_rotation_sensor.dart';
import 'package:sensors_plus/sensors_plus.dart' as sensors_plus;
import 'package:web_socket_channel/web_socket_channel.dart';

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
  double xMax = 0;
  double yMax = 0;
  double zMax = 0;

  String echo = '';

  bool shouldSendSensorData = false;

  late UdpService udp = UdpService(shouldSendSensorData: (bool value) { shouldSendSensorData = value; });

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
                Text(echo),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        onPressed: () {
                          setState(() {
                            udp.send(Input.pauseLeft);
                          });
                        },
                        text: '-',
                      ),
                      Button(
                        onPressed: () async {
                          ValueHolder vibration = await udp.send(Input.vibrate);

                          setState(() {
                            vibration.execute();
                          });
                        },
                        text: '+',
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -75),
                  child: ControlPad(
                    up: () {
                      setState(() {
                        udp.send(Input.keyUp);
                      });
                    },
                    down: () {
                      setState(() {
                        udp.send(Input.keyDown);
                      });
                    },
                    left: () {
                      setState(() {
                        udp.send(Input.keyLeft);
                      });
                    },
                    right: () {
                      setState(() {
                        udp.send(Input.keyRight);
                      });
                    },
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -75),
                  child: Button(
                    onPressed: () {
                      setState(() {
                        udp.send(Input.keyA);
                      });
                    },
                    text: 'A',
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Button(
                          onPressed: () {
                            setState(() {
                              udp.send(Input.key1);
                            });
                          },
                          text: '1',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Button(
                          onPressed: () {
                            setState(() {
                              udp.send(Input.key2);
                            });
                          },
                          text: '2',
                        ),
                      ],
                    ),
                  ),
                ),

                /*
                StreamBuilder(
                    stream: RotationSensor.orientationStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data!;
                        return Column(
                          children: [
                            Text("Orientation: ${data.eulerAngles.pitch}"),
                            Text("Orientation: ${data.eulerAngles.z}"),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return const Text("No data");
                      }
                    }),
                TextButton(
                    onPressed: () {
                      proximityEvents?.listen((ProximityEvent event) {
                        print("Proximity: ${event.proximity}");
                      });
                    },
                    child: Text("Press me")),
                StreamBuilder(
                    stream: sensors_plus.userAccelerometerEventStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data
                            as sensors_plus.UserAccelerometerEvent;

                        if (data.x > xMax) {
                          xMax = data.x;
                        }

                        if (data.y > yMax) {
                          yMax = data.y;
                        }

                        if (data.z > zMax) {
                          zMax = data.z;
                        }

                        return Column(
                          children: [
                            Text("Accelerometer: ${xMax.toStringAsFixed(2)}"),
                            // dauni, zuwe
                            Text("Accelerometer: ${yMax.toStringAsFixed(2)}"),
                            // links, rechts
                            Text("Accelerometer: ${zMax.toStringAsFixed(2)}"),
                            // aufi, owe
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return const Text("No data");
                      }
                    }),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
