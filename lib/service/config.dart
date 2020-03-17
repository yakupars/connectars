import 'package:connectars/config.dart';

class ConfigService {
  Config _config;

  factory ConfigService() {
    return _configService;
  }

  ConfigService._internal();

  static final ConfigService _configService = ConfigService._internal();

  set config(Config config) => _config = config;

  Config get config => _config;
}
