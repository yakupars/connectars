import 'dart:async';

import 'package:connectars/connectars.dart' as connectars;

void main(List<String> arguments) {
  runZoned(() => connectars.run(), onError: (exception) {
    // Todo: log to a file
    print(exception.toString());
  });
}
