import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/request_handler.dart';
import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/listener.dart';
import 'package:connectars/service/log.dart';
import 'package:dotenv/dotenv.dart';

void run() async {
  var server =
      await HttpServer.bind(env['SOCKET_HOST'], int.parse(env['SOCKET_PORT']));

  await for (HttpRequest request in server) {
    LogService().log('Time: ' + DateTime.now().toUtc().toString(),
        type: LogService.typeRequest);
    LogService()
        .log('Route: ' + request.uri.path, type: LogService.typeRequest);
    LogService().log('Method: ' + request.method, type: LogService.typeRequest);
    LogService().log('Headers: ' + request.headers.toString(),
        type: LogService.typeRequest);
    LogService().log('Query: ' + request.uri.queryParameters.toString(),
        type: LogService.typeRequest);
    LogService().log('Body: ' + await utf8.decodeStream(request),
        type: LogService.typeRequest);

    final response = request.response;

    Client client;
    if (request.uri.path == '/connect') {
      client = await connect(request);

      if (client is Client) {
        client.streamSubscription = listen(client);
        Connections.clients.add(client);

        client.isAlive = true;
        pingPongClient(client);
      }
    }

    if (request.uri.path == '/check') {
      await response.write(check(request));
      await response.close();
    }

    if (request.uri.path == '/list' && await authorize(request, response)) {
      await response.write(connections());
      await response.close();
    }

    if (request.uri.path == '/message' && await authorize(request, response)) {
      message(request);
      await response.close();
    }

    await response.close();
  }
}

Future<bool> authorize(HttpRequest request, HttpResponse response) async {
  if (request.headers.value('x-socket-token') != env['SOCKET_TOKEN']) {
    response.statusCode = 403;
    await response.close();
    return false;
  }

  return true;
}

void pingPongClient(Client client) {
  // check zombie sockets and clean them
  Timer(const Duration(seconds: 3), () {
    var pingMessage = GenericMessage(
        'ping', '00000000-0000-0000-0000-000000000000', [client.uuid], null);
    LogService().log('[O] ' + pingMessage.toMap().toString());

    client.webSocket.add(jsonEncode(pingMessage.toMap()));
    client.isAlive = false;

    Timer(const Duration(seconds: 5), () {
      if (client.isAlive == false) {
        client.webSocket.close();
        Connections.clients.remove(client);
      }
    });
  });
}
