import 'dart:convert';
import 'dart:io';

import 'package:connectarsy/message/generic_message.dart';
import 'package:connectarsy/service/log.dart';
import 'package:connectarsy/dao/client.dart';
import 'package:connectarsy/dao/connections.dart';
import 'package:connectarsy/service/pusher.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

Future<Client> connect(HttpRequest request) async {
  var token = request.headers.value('x-auth-token');

  var url = env['API_BASE'] + env['API_ROUTE_AUTH'];

  var response = await http.post(url, headers: {env['API_ROUTE_AUTH_HEADER']: token});

  String uuid;
  if (response.statusCode >= 200 && response.statusCode < 400) {
    uuid = response.body;
  } else {
    return null;
  }

  var client = Connections.clients.firstWhere((Client client) => client.uuid == uuid, orElse: () => null);

  if (client is Client) {
    LogService().log('Connection already exists.', type: LogService.typeRequest);

    return null;
  }

  var webSocket = await WebSocketTransformer.upgrade(request);

  return Client()
    ..token = token
    ..uuid = uuid
    ..webSocket = webSocket;
}

List<String> connections() {
  return List<String>.from(Connections.clients.map((Client client) => client.toString()));
}

void message(HttpRequest request) async {
  var incomingMap = jsonDecode(await utf8.decodeStream(request))['message'];
  LogService().log('Incoming message: ' + incomingMap.toString(), type: LogService.typeRequest);

  var outgoing = GenericMessage.map(incomingMap);

  push(outgoing);
}
