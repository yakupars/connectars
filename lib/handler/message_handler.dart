import 'dart:convert';

import 'package:connectars/message/generic_message.dart';
import 'package:connectars/service/pusher.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart';

Future<void> handle(String data) async {
  var incomingMap = jsonDecode(data);
  var incoming = GenericMessage.map(incomingMap);

  var url = env['API_HOST'] + ':' + env['API_PORT'].toString() + env['API_ROUTE'];

  var response = await post(url, body: {'message': jsonEncode(incoming.toMap())});

  if (response.statusCode >= 200 && response.statusCode < 400) {
    var body = jsonDecode(response.body);

    var outgoing = GenericMessage.map(body);

    push(outgoing);
  }
}
