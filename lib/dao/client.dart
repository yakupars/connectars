import 'dart:async';
import 'dart:io';

class Client {
  WebSocket webSocket;
  StreamSubscription streamSubscription;
  String token;
  String uuid;

  @override
  String toString() {
    return uuid;
  }
}
