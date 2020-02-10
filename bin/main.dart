import 'dart:async';

import 'package:connectars/connectars.dart' as connectars;
import 'package:dotenv/dotenv.dart';

void main(List<String> arguments) {
  // loading env vars
  load();

  runZoned(() => connectars.run(), onError: (exception) {
    // Todo: log to a file
    print(exception.toString());
  });
}
