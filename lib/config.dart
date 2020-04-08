import 'dart:io';

class Config {
  final String SERVER_HOST = InternetAddress.anyIPv4.address;
  final String SERVER_PORT = '4433';
  final String SERVER_CERTIFICATE_CHAIN_PATH = '/path/to/fullchain.pem/file';
  final String SERVER_PRIVATE_KEY_PATH = '/path/to/privkey.pem/file';

  final String SOCKET_TOKEN = '043a33f74f72fcae29bbf500deded817';
  final String SOCKET_PING_INTERVAL = '5';
  final String SOCKET_PING_RESPONSE_TIMEOUT = '3';
  final String SOCKET_LOG_PATH = '/tmp/log/connectars';

  final String API_SCHEME = 'https';
  final String API_BASE = InternetAddress.loopbackIPv4.address;
  final String API_PORT = '443';
  final String API_VERSION = 'v1';
  final String API_ROUTE_AUTH = '/websocket/init';
  final String API_ROUTE_AUTH_HEADER = 'x-api-token';
  final String API_ROUTE_MESSAGE = '/websocket/message';
  final String API_ROUTE_MESSAGE_PARAMETER = 'data';
}
