import 'dart:convert';

import 'package:connectars/dao/client.dart';
import 'package:connectars/dao/connections.dart';
import 'package:connectars/message/generic_message.dart';

void push(GenericMessage outgoing) {
  outgoing.to.forEach((String toUuid) {
    var client = Connections.clients.firstWhere((Client client) => client.uuid == toUuid, orElse: () => null);

    if (client is Client) {
      client.webSocket.add(jsonEncode(outgoing.toMap()));
    }
  });
}
