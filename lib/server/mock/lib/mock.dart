import 'dart:io';

void main() async {
  final server = await HttpServer.bind('localhost', 8080);
  print('Listening on localhost:${server.port}');

  server.listen((request) {
    if (WebSocketTransformer.isUpgradeRequest(request)) {
      WebSocketTransformer.upgrade(request).then((webSocket) {
        webSocket.listen((message) {
          print('Received message: $message');
          webSocket.add('Received message: $message');
        });
      });
    }
  });
}
