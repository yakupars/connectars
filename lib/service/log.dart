import 'dart:io';

import 'package:dotenv/dotenv.dart';

class LogService {
  factory LogService() {
    return _logService;
  }

  LogService._internal();

  static final LogService _logService = LogService._internal();

  static const typeException = 'exception';
  static const typeMessage = 'message';
  static const typeRequest = 'request';

  void log(String log, {String type = typeMessage}) {
    // loading env vars
    load();

    Directory(env['LOG_PATH']).create(recursive: true);

    final filename = env['LOG_PATH'] +
        '/${DateTime.now().year.toString()}-${DateTime.now().month.toString()}-${DateTime.now().day.toString()}-$type';

    File(filename).writeAsStringSync('$log\n', mode: FileMode.append);
  }
}
