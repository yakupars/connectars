import 'dart:async';
import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/message_handler.dart';
import 'package:connectars/service/log.dart';

StreamSubscription listen(Client client) {
  return client.webSocket.listen((data) => handle(data, client),
      onDone: () => _onDone(client.webSocket),
      onError: (error) => _onError(client.webSocket, error),
      cancelOnError: false);
}

void _onDone(WebSocket webSocket) {
  Connections.clients
      .removeWhere((Client client) => client.webSocket == webSocket);
  webSocket.close();
}

void _onError(WebSocket webSocket, error) {
  LogService().log(error.toString(), type: LogService.typeException);

  Connections.clients
      .removeWhere((Client client) => client.webSocket == webSocket);

  webSocket.close();
}
