import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/service/log.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart' as http;

Future<Client> handle(HttpRequest request) async {
  if (request.uri.path == env['SOCKET_ROUTE_CONNECT']) {
    var token = request.headers.value(env['API_AUTH_HEADER_NAME']);

    var url = env['API_BASE'] + env['API_ROUTE_INIT'];

    var response = await http.post(url, headers: {env['API_AUTH_HEADER_NAME']: token});

    String uuid;
    if (response.statusCode >= 200 && response.statusCode < 400) {
      uuid = response.body;
    } else {
      return null;
    }

    if (!Connections.uuidSet.add(uuid)) {
      LogService().log('Connection already exists.', type: LogService.typeRequest);

      return null;
    }

    var webSocket = await WebSocketTransformer.upgrade(request);

    return Client()
      ..uuid = uuid
      ..webSocket = webSocket;
  }

  LogService().log('Route not found: ' + request.uri.path, type: LogService.typeRequest);

  return null;
}
