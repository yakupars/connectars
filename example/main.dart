import 'package:connectars/config.dart';
import 'package:connectars/connectars.dart' as connectars;

void main(List<String> arguments) {
  connectars.run(ConfigCustom());
}

class ConfigCustom extends Config {
  @override
  final String SOCKET_LOG_PATH = '/var/log/some-project';
}
