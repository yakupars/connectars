import 'dart:async';
import 'dart:io';

class Client {
  WebSocket webSocket;
  StreamSubscription streamSubscription;
  String token;
  String uuid;
  bool isAlive;

  @override
  String toString() {
    return uuid;
  }
}
