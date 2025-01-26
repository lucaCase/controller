import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:validator_regex/validator_regex.dart';

import '../dto/server.dart';

class ServerSelection extends StatefulWidget {
  ServerSelection({super.key});

  @override
  State<ServerSelection> createState() => _ServerSelectionState();
}

class _ServerSelectionState extends State<ServerSelection> {
  List<Server> servers = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getServers().then((value) {
      setState(() {
        servers = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Server Selection"),
      ),
      body: ListView.builder(
              itemCount: servers.length + 1,
              itemBuilder: (context, index) {
                if (index == servers.length) {
                  // Add server button
                  return ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text("Add Server"),
                    onTap: () => _showAddServerDialog(),
                  );
                } else {
                  // Display server list
                  return ListTile(
                    leading: const Icon(Icons.computer),
                    title: Text(servers[index].name),
                    subtitle: Text(
                      "${servers[index].ip.address}:${servers[index].port}",
                      style:
                          const TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _showEditServerDialog(index),
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => _showDeleteServerDialog(index),
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed("/server-connection", arguments: servers[index]);
                    },
                  );
                }
              },
            ),
    );
  }

  Future<List<Server>> getServers() async {
    final file = await _localFile;
    List<Server> loadedServers = [];

    try {
      if (!await file.exists()) {
        await file.create();
        await file.writeAsString(json.encode([]));
      }

      String contents = await file.readAsString();

      if (contents.isNotEmpty) {
        List<dynamic> jsonList = json.decode(contents);

        for (var jsonServer in jsonList) {
          loadedServers.add(Server.fromJson(jsonServer));
        }
      }
    } catch (e) {
      print("Error reading servers: $e");
    }

    print(loadedServers);

    //return loadedServers;

    return [Server(name: "Duz trottl", ip: InternetAddress("192.168.178.118"), port: 11000, games: [])];
  }


  Future<void> writeServers() async {
    final file = await _localFile;

    await file.writeAsString(json.encode(servers));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/servers.json');
  }

  void _showAddServerDialog() {
    nameController.clear();
    addressController.clear();
    portController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Server"),
          content: _serverInputFields(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  servers.add(Server(
                    name: nameController.text,
                    ip: InternetAddress(addressController.text),
                    port: int.parse(portController.text),
                      games: [],
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showEditServerDialog(int index) {
    nameController.text = servers[index].name;
    addressController.text = servers[index].ip.address;
    portController.text = servers[index].port.toString();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Server"),
          content: _serverInputFields(),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  if (nameController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      portController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill out all fields"),
                      ),
                    );
                    return;
                  }

                  if (!Validator.ipAddress(addressController.text)) {
                    addressController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid IP address"),
                      ),
                    );
                    return;
                  }

                  try {
                    int.parse(portController.text);
                  } catch (e) {
                    portController.text = "1";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Port must be a number"),
                      ),
                    );
                    return;
                  }

                  if (int.parse(portController.text) < 1) {
                    portController.text = "1";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Port must be greater than 0"),
                      ),
                    );
                    return;
                  } else if (int.parse(portController.text) > 65535) {
                    portController.text = "65535";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Port must be less than 65536"),
                      ),
                    );
                    return;
                  }

                  servers[index] = Server(
                    name: nameController.text,
                    ip: InternetAddress(addressController.text),
                    port: int.parse(portController.text),
                    lastUpdate: servers[index].lastUpdate,
                    games: servers[index].games,
                  );

                  writeServers();

                  Navigator.pop(context);
                });
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteServerDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Server"),
          content: const Text("Are you sure you want to delete this server?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  servers.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Widget _serverInputFields() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: "Name"),
            maxLength: 30,
          ),
          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: "Address"),
            maxLength: 15,
          ),
          TextField(
            controller: portController,
            decoration: const InputDecoration(labelText: "Port"),
            maxLength: 5,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}
