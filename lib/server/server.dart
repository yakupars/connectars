import 'dart:convert';
import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/request_handler.dart';
import 'package:connectars/service/listener.dart';
import 'package:connectars/service/log.dart';
import 'package:dotenv/dotenv.dart';

void run() async {
  var server = await HttpServer.bind(env['SOCKET_HOST'], int.parse(env['SOCKET_PORT']));

  await for (HttpRequest request in server) {
    LogService().log('Route: ' + request.uri.path, type: LogService.typeRequest);
    LogService().log('Method: ' + request.method, type: LogService.typeRequest);
    LogService().log('Headers: ' + request.headers.toString(), type: LogService.typeRequest);
    LogService().log('Query: ' + request.uri.queryParameters.toString(), type: LogService.typeRequest);
    LogService().log('Body: ' + await utf8.decodeStream(request), type: LogService.typeRequest);

    final response = request.response;

    var client = await handle(request);
    LogService().log('\n' + '~o' * 50 + '~\n', type: LogService.typeRequest);

    if (client is Client) {
      client.streamSubscription = listen(client.webSocket);
      Connections.clients.add(client);
    } else {
      // client already exists or route does not exists.
      await response.close();
    }
  }
}
