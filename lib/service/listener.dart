import 'dart:async';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/message_handler.dart';
import 'package:connectars/service/log.dart';

StreamSubscription listen(Client client) {
  return client.webSocket.listen((data) => handle(data, client),
      onDone: () => _onDone(client),
      onError: (error) => _onError(client, error),
      cancelOnError: false);
}

void _onDone(Client client) {
  LogService().log(client.uuid + ' done. \n', type: LogService.typeRequest);

  client.webSocket.close();
  client.pingTimer.cancel();
  Connections.clients
      .removeWhere((Client clientInList) => clientInList.uuid == client.uuid);
}

void _onError(Client client, error) {
  LogService().log(client.uuid + ' error. ' + error.toString(),
      type: LogService.typeException);

  client.webSocket.close();
  client.pingTimer.cancel();
  Connections.clients
      .removeWhere((Client clientInList) => clientInList.uuid == client.uuid);
}
