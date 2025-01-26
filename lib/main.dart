import 'package:controller/pages/about.dart';
import 'package:controller/pages/controller.dart';
import 'package:controller/pages/home.dart';
import 'package:controller/pages/server_connection.dart';
import 'package:controller/pages/server_selection.dart';
import 'package:controller/pages/settings.dart';
import 'package:controller/pages/users_manual.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/home",
      routes: {
        "/home": (context) => const Home(),
        "/server-selection": (context) => ServerSelection(),
        "/server-connection": (context) => const ServerConnection(),
        "/controller": (context) => const Controller(),
        "/users-manual": (context) => const UsersManual(),
        "/settings": (context) => const Settings(),
        "/about": (context) => const About(),
      },
    );
  }
}
