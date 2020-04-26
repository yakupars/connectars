import 'dart:convert';

import 'package:connectars/dao/client.dart' as client;
import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/config.dart';
import 'package:connectars/service/log.dart';
import 'package:connectars/service/pusher.dart';
import 'package:http/http.dart';

Future<void> handle(data, client.Client client) async {
  if (data is! String) {
    LogService().log('Data is not string. Data: ' + data.toString());
    return;
  }

  Map<String, dynamic> incomingMap = jsonDecode(data);

  if (!incomingMap.containsKey('_id') ||
      incomingMap['_id'] is! String ||
      !incomingMap.containsKey('from') ||
      incomingMap['from'] is! String ||
      !incomingMap.containsKey('to') ||
      incomingMap['to'] is! List ||
      !incomingMap.containsKey('data') ||
      incomingMap['data'] is! Map) {
    LogService().log('Message structure is not valid.');
    LogService().log('[I] ' +
        new DateTime.now().toUtc().toString() +
        ' ' +
        incomingMap.toString());
    return;
  }

  var incoming = GenericMessage.map(incomingMap);

  LogService().log('[I] ' +
      new DateTime.now().toUtc().toString() +
      ' ' +
      incoming.toMap().toString());

  if (incoming.id == 'pong') {
    client.isAlive = true;
    return;
  }

  var url = ConfigService().config.API_SCHEME +
      '://' +
      ConfigService().config.API_BASE +
      ':' +
      ConfigService().config.API_PORT +
      '/' +
      ConfigService().config.API_VERSION +
      ConfigService().config.API_ROUTE_MESSAGE;

  var response = await post(url, body: {
    ConfigService().config.API_ROUTE_MESSAGE_PARAMETER:
        jsonEncode(incoming.toMap())
  }, headers: {
    ConfigService().config.API_ROUTE_AUTH_HEADER: client.token
  });

  Map<String, dynamic> body = jsonDecode(response.body);
  var outgoing = GenericMessage.map(body);

  LogService().log('[O] ' +
      new DateTime.now().toUtc().toString() +
      ' ' +
      outgoing.toMap().toString());

  if (response.statusCode >= 200 && response.statusCode < 400) {
    push(outgoing);
  }
}
