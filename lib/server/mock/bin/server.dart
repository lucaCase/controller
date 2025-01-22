import 'dart:io';

void main() async {
  final port = 8080; // Port to listen on

  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    port,
  );
  print('WebSocket server is running on ws://localhost:$port');

  await for (HttpRequest request in server) {
    if (request.uri.path == '/ws' && WebSocketTransformer.isUpgradeRequest(request)) {
      final socket = await WebSocketTransformer.upgrade(request);
      print('WebSocket connection established');

      // Handle incoming messages
      socket.listen(
        (message) {
          print('Received: $message');
          // Echo the message back to the client
          socket.add('Echo: $message');
        },
        onDone: () {
          print('WebSocket connection closed');
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
      );
    } else {
      // Respond with a 404 if the endpoint is not /ws or the request isn't a WebSocket upgrade
      request.response
        ..statusCode = HttpStatus.notFound
        ..close();
    }
  }
}
