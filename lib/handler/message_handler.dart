import 'dart:convert';

import 'package:connectars/dao/client.dart' as client;
import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/config.dart';
import 'package:connectars/service/log.dart';
import 'package:connectars/service/pusher.dart';
import 'package:http/http.dart';

Future<void> handle(data, client.Client client) async {
  var incomingMap = jsonDecode(data) as Map<String, dynamic>;

  LogService().log('[I] ' + incomingMap.toString());

  var incoming = GenericMessage.map(incomingMap);

  if (incoming.id == 'pong') {
    client.isAlive = true;
    return;
  }

  var url = ConfigService().config.API_BASE +
      ConfigService().config.API_ROUTE_MESSAGE;

  var response = await post(url, body: {
    ConfigService().config.API_ROUTE_MESSAGE_PARAMETER:
        jsonEncode(incoming.toMap())
  });

  if (response.statusCode >= 200 && response.statusCode < 400) {
    LogService().log('[O] ' + response.body);

    var body = jsonDecode(response.body);

    var outgoing = GenericMessage.map(body);

    push(outgoing);
  }
}
