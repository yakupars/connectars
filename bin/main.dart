import 'dart:async';

import 'package:connectars/connectars.dart';
import 'package:connectars/service/log.dart';

void main(List<String> arguments) {
  runZoned(() => run(), onError: (exception, stack) {
    LogService().log(exception.toString(), type: LogService.typeException);
    LogService().log(stack.toString(), type: LogService.typeException);
  });
}
