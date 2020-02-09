import 'package:connectars/dao/connections.dart';

void handle(var data) {
  print(data.toString());
  print(Connections.clients.toString());
}
