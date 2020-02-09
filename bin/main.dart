import 'package:connectars/connectars.dart' as connectars;
import 'package:dotenv/dotenv.dart';

void main(List<String> arguments) {
  // load env vars
  load();

  // run project
  connectars.run();
}
