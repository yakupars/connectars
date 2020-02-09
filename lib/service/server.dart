import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/request_handler.dart';
import 'package:connectars/service/listener.dart';

void serve() async {
  var server = await HttpServer.bind(InternetAddress.anyIPv4, 4433);

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
