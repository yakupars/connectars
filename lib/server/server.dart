import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectars/config.dart';
import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/handler/request_handler.dart';
import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/config.dart';
import 'package:connectars/service/listener.dart';
import 'package:connectars/service/log.dart';
import 'package:http/http.dart' as http;

void run(Config config) async {
  ConfigService()..config = config;

  HttpServer server;
  if (await File(ConfigService().config.SERVER_CERTIFICATE_CHAIN_PATH)
          .exists() &&
      await File(ConfigService().config.SERVER_PRIVATE_KEY_PATH).exists()) {
    var serverContext = SecurityContext()
      ..useCertificateChain(
          ConfigService().config.SERVER_CERTIFICATE_CHAIN_PATH)
      ..usePrivateKey(ConfigService().config.SERVER_PRIVATE_KEY_PATH);

    server = await HttpServer.bindSecure(ConfigService().config.SERVER_HOST,
        int.parse(ConfigService().config.SERVER_PORT), serverContext);
  } else {
    server = await HttpServer.bind(ConfigService().config.SERVER_HOST,
        int.parse(ConfigService().config.SERVER_PORT));
  }

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

        var url = ConfigService().config.API_SCHEME +
            ConfigService().config.API_BASE +
            ':' +
            ConfigService().config.API_PORT +
            '/' +
            ConfigService().config.API_VERSION +
            ConfigService().config.API_ROUTE_MESSAGE;
        var connectMessage = GenericMessage('connect', client.uuid,
            ['00000000-0000-0000-0000-000000000000'], null);

        await http.post(url, body: {
          ConfigService().config.API_ROUTE_MESSAGE_PARAMETER:
              jsonEncode(connectMessage.toMap())
        });

        client.isAlive = true;
        pingPongClient(client);
      }
    }

    if (request.uri.path == '/disconnect') {
      await response.write(await disconnect(request));
      await response.close();
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
  if (request.headers.value('x-socket-token') !=
      ConfigService().config.SOCKET_TOKEN) {
    response.statusCode = 403;
    await response.close();
    return false;
  }

  return true;
}

void pingPongClient(Client client) {
  // check zombie sockets and clean them
  if (client.pingTimer == null) {
    var pingInterval = int.parse(ConfigService().config.SOCKET_PING_INTERVAL);
    var pingResponseTimeout =
        int.parse(ConfigService().config.SOCKET_PING_RESPONSE_TIMEOUT);

    var timer = Timer.periodic(Duration(seconds: pingInterval), (Timer timer) {
      if (client.isAlive) {
        var pingMessage = GenericMessage('ping',
            '00000000-0000-0000-0000-000000000000', [client.uuid], null);
        LogService().log('[O] ' + pingMessage.toMap().toString());

        client.isAlive = false;
        client.webSocket.add(jsonEncode(pingMessage.toMap()));

        Timer(Duration(seconds: pingResponseTimeout), () {
          if (client.isAlive == false) {
            var url = ConfigService().config.API_SCHEME +
                ConfigService().config.API_BASE +
                ':' +
                ConfigService().config.API_PORT +
                '/' +
                ConfigService().config.API_VERSION +
                ConfigService().config.API_ROUTE_MESSAGE;
            var disconnectMessage = GenericMessage('disconnect', client.uuid,
                ['00000000-0000-0000-0000-000000000000'], null);

            http.post(url, body: {
              ConfigService().config.API_ROUTE_MESSAGE_PARAMETER:
                  jsonEncode(disconnectMessage.toMap())
            });

            client.webSocket.close();
            client.pingTimer.cancel();
            Connections.clients.remove(client);
          }
        });
      } else {
        client.webSocket.close();
        client.pingTimer.cancel();
        Connections.clients.remove(client);
      }
    });

    client.pingTimer = timer;
  }
}
