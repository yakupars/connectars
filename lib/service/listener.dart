import 'dart:async';
import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/message_handler.dart';

StreamSubscription listen(WebSocket webSocket) {
  return webSocket.listen((data) => handle(data), onDone: () => _onDone(webSocket), onError: (error) => _onError(webSocket, error), cancelOnError: false);
}

void _onDone(WebSocket webSocket) {
  Connections.clients.removeWhere((Client client) {
    return client.webSocket == webSocket ? Connections.uuidSet.remove(client.uuid) : false;
  });
  webSocket.close();
}

void _onError(WebSocket webSocket, error) {
  Connections.clients.removeWhere((Client client) {
    return client.webSocket == webSocket ? Connections.uuidSet.remove(client.uuid) : false;
  });
  webSocket.close();
}