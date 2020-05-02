import 'dart:async';
import 'dart:io';

class Client {
  WebSocket webSocket;
  String token;
  String uuid;
  bool isAlive;
  Timer pingTimer;

  @override
  String toString() {
    return uuid;
  }
}
