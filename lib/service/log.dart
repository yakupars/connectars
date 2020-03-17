import 'dart:io';

import 'package:connectars/service/config.dart';

class LogService {
  factory LogService() {
    return _logService;
  }

  LogService._internal();

  static final LogService _logService = LogService._internal();

  static const typeException = 'exception';
  static const typeMessage = 'message';
  static const typeRequest = 'request';

  void log(String log, {String type = typeMessage}) async {
    await Directory(ConfigService().config.SOCKET_LOG_PATH)
        .create(recursive: true);

    final filename = ConfigService().config.SOCKET_LOG_PATH +
        '/${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}-$type';

    File(filename).writeAsStringSync('$log\n', mode: FileMode.append);
  }
}
