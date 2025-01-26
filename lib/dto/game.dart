import 'package:uuid/uuid.dart';

class Game {
  String id;
  String title;
  String description;
  String image;

  Game({
    String? id,
    required this.title,
    required this.description,
    required this.image,
  }) : id = id ?? const Uuid().v4();

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
