import 'dart:convert';

import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/log.dart';
import 'package:connectars/service/pusher.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart';

Future<void> handle(String data) async {
  LogService().log('Incoming message: ' + data);

  var incomingMap = jsonDecode(data);
  var incoming = GenericMessage.map(incomingMap);

  var url = env['API_BASE'] + env['API_ROUTE_MESSAGE'];

  var response = await post(url, body: {env['API_ROUTE_MESSAGE_PARAMETER']: jsonEncode(incoming.toMap())});

  if (response.statusCode >= 200 && response.statusCode < 400) {
    LogService().log('Outgoing message: ' + response.body);
    LogService().log('\n' + '~o' * 50 + '~\n');

    var body = jsonDecode(response.body);

    var outgoing = GenericMessage.map(body);

    push(outgoing);
  }
}
