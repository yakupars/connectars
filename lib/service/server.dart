import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/request_handler.dart';
import 'package:connectars/service/listener.dart';
import 'package:dotenv/dotenv.dart';

void serve() async {
  var server = await HttpServer.bind(env['SOCKET_HOST'], int.parse(env['SOCKET_PORT']));

  await for (HttpRequest request in server) {
    final response = request.response;

    var client = await handle(request);

    if (client is Client) {
      client.streamSubscription = listen(client.webSocket);
      Connections.clients.add(client);
    } else {
      // client already exists or route does not exists.
      await response.close();
    }
  }
}
