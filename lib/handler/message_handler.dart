import 'dart:convert';

import 'package:connectars/message/Incoming.dart';
import 'package:connectars/message/Outgoing.dart';
import 'package:connectars/service/pusher.dart';
import 'package:dotenv/dotenv.dart';
import 'package:http/http.dart';

Future<void> handle(String data) async {
  var incomingMap = jsonDecode(data);
  var incoming = Incoming.map(incomingMap);

  var url = env['API_HOST'] + ':' + env['SOCKET_PORT'] + incoming.route;

  Response response;
  switch (incoming.verb) {
    case 'post':
      response = await post(url, headers: incoming.headers, body: incoming.body);
      break;
    case 'get':
      response = await get(url, headers: incoming.headers);
      break;
  }

  if (response.statusCode >= 200 && response.statusCode < 400) {
    var body = jsonDecode(response.body);

    var outgoing = Outgoing.map(body);

    push(outgoing);
  }
}
