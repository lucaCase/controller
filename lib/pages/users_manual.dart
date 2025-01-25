import 'package:flutter/material.dart';

class UsersManual extends StatelessWidget {
  const UsersManual({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Center(child: Text("PhoController")),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Users Manual",
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
                Text(
                  "How to use PhoController",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "1. Open the app",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "2. Click on 'Get Started'",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "3. Click on 'Start Controller'",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "4. Open the controller on your computer",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "5. Use the controller to control your phone",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
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
