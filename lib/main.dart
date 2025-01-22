import 'dart:async';
import 'dart:io';

import 'package:all_sensors/all_sensors.dart';
import 'package:controller/components/button.dart';
import 'package:controller/components/control_pad.dart';
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


  late WebSocketChannel channel =
      WebSocketChannel.connect(Uri.parse("wss://echo.websocket.events"));


  @override
  void initState() {
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
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
              /*Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Button(
                      onPressed: () {
                        channel.sink.add(Input.pauseLeft.name);
                      },
                      text: '-',
                    ),
                    Button(
                      onPressed: () {
                        channel.sink.add(Input.pauseRight.name);
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
                    channel.sink.add(Input.keyUp.name);
                  },
                  down: () {
                    channel.sink.add(Input.keyDown.name);
                  },
                  left: () {
                    channel.sink.add(Input.keyLeft.name);
                  },
                  right: () {
                    channel.sink.add(Input.keyRight.name);
                  },
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -75),
                child: Button(
                  onPressed: () {
                    channel.sink.add(Input.keyA.name);
                  },
                  text: 'A',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Button(
                      onPressed: () {
                        channel.sink.add(Input.key2.name);
                      },
                      text: '1',
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Button(
                      onPressed: () {
                        channel.sink.add(Input.key2.name);
                      },
                      text: '2',
                    ),
                  ],
                ),
              ),

               */
              StreamBuilder(stream: RotationSensor.orientationStream,  builder: (context, snapshot) {
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
              TextButton(onPressed: () {
                proximityEvents?.listen((ProximityEvent event) {
                  print("Proximity: ${event.proximity}");
                });
              }, child: Text("Press me")),
              StreamBuilder(stream: sensors_plus.accelerometerEventStream(), builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as sensors_plus.AccelerometerEvent;
                  return Column(
                    children: [
                      Text("Accelerometer: ${data.x}"),
                      Text("Accelerometer: ${data.y}"),
                      Text("Accelerometer: ${data.z}"),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const Text("No data");
                }
              }),
            ],
          ),
        ),
      )),
    );
  }
}
