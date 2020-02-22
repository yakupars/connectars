import 'package:connectars/service/server.dart';
import 'package:dotenv/dotenv.dart';

void run() async {
  // loading env vars
  load();

  await serve();
}
