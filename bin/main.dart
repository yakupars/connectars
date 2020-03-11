import 'dart:async';

import 'package:connectarsy/connectarsy.dart';
import 'package:connectarsy/service/log.dart';
import 'package:dotenv/dotenv.dart';

void main(List<String> arguments) {
  // loading env vars
  load();

  runZoned(() => run(), onError: (exception, stack) {
    LogService().log(exception.toString(), type: LogService.typeException);
    LogService().log(stack.toString(), type: LogService.typeException);
    LogService().log('\n' + '~o' * 50 + '~\n', type: LogService.typeException);
  });
}
