import 'dart:async';
import 'dart:io';

class Client {
  WebSocket webSocket;
  StreamSubscription streamSubscription;
  String uuid;

  @override
  String toString() {
    return uuid;
  }
}
