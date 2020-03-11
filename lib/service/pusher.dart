import 'dart:convert';

import 'package:connectarsy/dao/client.dart';
import 'package:connectarsy/dao/connections.dart';
import 'package:connectarsy/message/generic_message.dart';

void push(GenericMessage outgoing) {
  outgoing.to.forEach((String toUuid) {
    var client = Connections.clients.firstWhere((Client client) => client.uuid == toUuid, orElse: () => null);

    if (client is Client) {
      client.webSocket.add(jsonEncode(outgoing.toMap()));
    }
  });
}
