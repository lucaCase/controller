import 'package:controller/components/page_direct_button.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 2750),
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: const Text(
                        "PhoController",
                        style:
                            TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: 1),
                  curve: Curves.ease,
                  duration: const Duration(milliseconds: 2750),
                  builder: (context, opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: const Text(
                        "A controller for your phone",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                      ),
                    );
                  },
                ),
                const Column(
                  children: [
                    PageDirectButton(title: "Get started", route: "/server-selection"),
                    PageDirectButton(title: "Settings", route: "/settings"),
                    PageDirectButton(title: "Users Manual", route: "/users-manual"),
                    PageDirectButton(title: "About", route: "/about"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
