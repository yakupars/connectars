import 'dart:async';
import 'dart:io';

import 'package:connectarsy/dao/client.dart';
import 'package:connectarsy/dao/connections.dart';
import 'package:connectarsy/handler/message_handler.dart';
import 'package:connectarsy/service/log.dart';

StreamSubscription listen(WebSocket webSocket) {
  return webSocket.listen((data) {
    webSocket.pingInterval = Duration(seconds: 1);
    handle(data);
  }, onDone: () => _onDone(webSocket), onError: (error) => _onError(webSocket, error), cancelOnError: false);
}

void _onDone(WebSocket webSocket) {
  Connections.clients.removeWhere((Client client) => client.webSocket == webSocket);
  webSocket.close();
}

void _onError(WebSocket webSocket, error) {
  LogService().log(error.toString(), type: LogService.typeException);

  Connections.clients.removeWhere((Client client) => client.webSocket == webSocket);

  webSocket.close();
}
