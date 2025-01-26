import 'package:carousel_slider/carousel_slider.dart';
import 'package:controller/dto/server.dart';
import 'package:controller/services/udp_service.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class ServerConnection extends StatefulWidget {
  const ServerConnection({super.key});

  @override
  State<ServerConnection> createState() => _ServerConnectionState();
}

class _ServerConnectionState extends State<ServerConnection> {
  Server? server;

  @override
  Widget build(BuildContext context) {
    server = server ?? ModalRoute.of(context)!.settings.arguments as Server;

    print(server!.games);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Server")),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              server!.name,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
            ),
            Text(
              "IPv4: ${server!.ip.address}:${server!.port}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            server!.games.isNotEmpty ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Played games:", style: TextStyle(fontSize: 20)),
            ) : const SizedBox(),
            server!.games.length > 1
                ? CarouselSlider(
              items: server!.games.asMap().entries.map((entry) {
                return Image.network(entry.value.image);
              }).toList(),
              options: CarouselOptions(
                height: 300,
                autoPlay: true,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                viewportFraction: 0.8,
                enlargeFactor: 1,
                autoPlayAnimationDuration:
                const Duration(milliseconds: 1500),
              ),
            )
                : (server!.games.length == 1
                ? Image.network(server!.games[0].image)
                : const SizedBox()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: server!.lastUpdate != null
                  ? Text(
                  "Last connection to this server: ${timeago.format(server!.lastUpdate!)}")
                  : const SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      double time = await UdpService.sendPing(server!.ip, server!.port);

                      if (time == -1) {
                        print("Ping failed");
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Ping failed"), duration: Duration(seconds: 1),));
                      } else {
                        print("Ping successful: $time ms");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 1),
                            content: Text("Ping successful: $time ms")));
                      }

                    }, child: const Text("Ping server")),
                ElevatedButton(onPressed: () {
                  Navigator.pushNamed(context, "/controller", arguments: server);
                }, child: const Text("Connect")),
              ],
            )
          ],
        ),
      ),
    );
  }
}