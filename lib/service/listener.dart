import 'dart:async';
import 'dart:convert';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/message_handler.dart';
import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/config.dart';
import 'package:connectars/service/log.dart';
import 'package:http/http.dart' as http;

StreamSubscription listen(Client client) {
  return client.webSocket.listen((data) => handle(data, client),
      onDone: () => _onDone(client),
      onError: (error) => _onError(client, error),
      cancelOnError: false);
}

void _onDone(Client client) {
  LogService().log(client.uuid + ' done. \n', type: LogService.typeRequest);

  var url = ConfigService().config.API_SCHEME +
      '://' +
      ConfigService().config.API_BASE +
      ':' +
      ConfigService().config.API_PORT +
      '/' +
      ConfigService().config.API_VERSION +
      ConfigService().config.API_ROUTE_MESSAGE;
  var disconnectMessage = GenericMessage(
      'disconnect', client.uuid, ['00000000-0000-0000-0000-000000000000'], {});

  http.post(url, body: {
    ConfigService().config.API_ROUTE_MESSAGE_PARAMETER:
        jsonEncode(disconnectMessage.toMap())
  }, headers: {
    ConfigService().config.API_ROUTE_AUTH_HEADER: client.token
  });

  client.webSocket.close();
  if (client.pingTimer != null) {
    client.pingTimer.cancel();
  }
  Connections.clients
      .removeWhere((Client clientInList) => clientInList.uuid == client.uuid);
}

void _onError(Client client, error) {
  LogService().log(client.uuid + ' error. ' + error.toString(),
      type: LogService.typeException);

  var url = ConfigService().config.API_SCHEME +
      '://' +
      ConfigService().config.API_BASE +
      ':' +
      ConfigService().config.API_PORT +
      '/' +
      ConfigService().config.API_VERSION +
      ConfigService().config.API_ROUTE_MESSAGE;
  var disconnectMessage = GenericMessage(
      'disconnect', client.uuid, ['00000000-0000-0000-0000-000000000000'], {});

  http.post(url, body: {
    ConfigService().config.API_ROUTE_MESSAGE_PARAMETER:
        jsonEncode(disconnectMessage.toMap())
  }, headers: {
    ConfigService().config.API_ROUTE_AUTH_HEADER: client.token
  });

  client.webSocket.close();
  if (client.pingTimer != null) {
    client.pingTimer.cancel();
  }
  Connections.clients
      .removeWhere((Client clientInList) => clientInList.uuid == client.uuid);
}
