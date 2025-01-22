import 'dart:html';

void main() {
  final webSocket = WebSocket("ws://localhost:8080");

  webSocket.onOpen.listen((event) {
    print("WebSocket connected");
    webSocket.send("Hello Server");
  });

  webSocket.onMessage.listen((event) {
    print("Received message: ${event.data}");
  });

  webSocket.onClose.listen((event) {
    print("WebSocket disconnected");
  });
}
