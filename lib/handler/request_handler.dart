import 'dart:io';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';

Future<Client> handle(HttpRequest request) async {
  if (request.uri.path == '/connect') {
    /**
     * Todo: change token with uuid when api implementation is done !
     */
//    var token = request.headers.value('x-api-token');
    var uuid = request.headers.value('x-uuid');

    /**
     * Todo: check user creds to create socket connection
     * We are going to send request to api for that so we must prepare our request first !
     */
//    var uuid = '4a4b21ba-6329-4300-aa25-6de92095f8a1';

    if (!Connections.uuidSet.add(uuid)) {
      return null;
    }

    var webSocket = await WebSocketTransformer.upgrade(request);

    return Client()
      ..uuid = uuid
      ..webSocket = webSocket;
  }

  return null;
}
