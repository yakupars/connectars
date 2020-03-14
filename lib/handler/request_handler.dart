import 'dart:convert';
import 'dart:io';

import 'package:connectars/config.dart';
import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/log.dart';
import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/service/pusher.dart';
import 'package:http/http.dart' as http;

Future<Client> connect(HttpRequest request) async {
  var token = request.headers.value('x-auth-token');

  var url = Config.API_BASE + Config.API_ROUTE_AUTH;

  var response =
      await http.post(url, headers: {Config.API_ROUTE_AUTH_HEADER: token});

  String uuid;
  if (response.statusCode >= 200 && response.statusCode < 400) {
    uuid = jsonDecode(response.body);
  } else {
    return null;
  }

  var client = Connections.clients
      .firstWhere((Client client) => client.uuid == uuid, orElse: () => null);

  if (client is Client) {
    LogService()
        .log('Connection already exists.', type: LogService.typeRequest);

    return null;
  }

  var webSocket = await WebSocketTransformer.upgrade(request);

  return Client()
    ..token = token
    ..uuid = uuid
    ..webSocket = webSocket;
}

bool check(HttpRequest request) {
  var uuid = request.uri.queryParameters['uuid'];

  var client = Connections.clients
      .firstWhere((Client client) => client.uuid == uuid, orElse: () => null);

  if (client is Client) {
    return true;
  } else {
    return false;
  }
}

List<String> connections() {
  return List<String>.from(
      Connections.clients.map((Client client) => client.toString()));
}

void message(HttpRequest request) async {
  var incomingMap = jsonDecode(await utf8.decodeStream(request))['message'];
  LogService()
      .log('[I] ' + incomingMap.toString(), type: LogService.typeRequest);

  var outgoing = GenericMessage.map(incomingMap);

  push(outgoing);
}
