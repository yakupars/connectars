import 'dart:convert';
import 'dart:io';

import 'package:connectarsy/dao/client.dart';
import 'package:connectarsy/dao/connections.dart';
import 'package:connectarsy/handler/request_handler.dart';
import 'package:connectarsy/service/listener.dart';
import 'package:connectarsy/service/log.dart';
import 'package:dotenv/dotenv.dart';

void run() async {
  var server = await HttpServer.bind(env['SOCKET_HOST'], int.parse(env['SOCKET_PORT']));

  await for (HttpRequest request in server) {
    LogService().log('Time: ' + DateTime.now().toUtc().toString(), type: LogService.typeRequest);
    LogService().log('Route: ' + request.uri.path, type: LogService.typeRequest);
    LogService().log('Method: ' + request.method, type: LogService.typeRequest);
    LogService().log('Headers: ' + request.headers.toString(), type: LogService.typeRequest);
    LogService().log('Query: ' + request.uri.queryParameters.toString(), type: LogService.typeRequest);
    LogService().log('Body: ' + await utf8.decodeStream(request), type: LogService.typeRequest);

    final response = request.response;

    var client;
    if (request.uri.path == '/connect') {
      client = await connect(request);

      if (client is Client) {
        client.streamSubscription = listen(client.webSocket);
        Connections.clients.add(client);
      }
    }

    if (request.uri.path == '/list' && await authorize(request, response)) {
      await response.write(connections());
      await response.close();
    }

    if (request.uri.path == '/message' && await authorize(request, response)) {
      message(request);
      await response.close();
    }

    LogService().log('\n' + '~o' * 50 + '~\n', type: LogService.typeRequest);

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
