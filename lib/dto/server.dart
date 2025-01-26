import 'dart:io';

import 'package:controller/dto/game.dart';

class Server {
  String name;
  InternetAddress ip;
  int port;
  DateTime? lastUpdate;
  List<Game> games = [];

  Server({required this.name, required this.ip, required this.port, this.lastUpdate, required this.games});

  @override
  String toString() {
    return "Server{name: $name, address: $ip, port: $port}";
  }

  factory Server.fromJson(Map<String, dynamic> json) {
    return Server(
      name: json['name'],
      ip: InternetAddress(json['ip']),
      port: json['port'] as int,
      lastUpdate: json["lastUpdate"] != null ? DateTime.parse(json['lastUpdate']) : null,
      games: List<Game>.from(json['games'].map((game) => Game.fromJson(game))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ip': ip.address,
      'port': port,
    };
  }
}