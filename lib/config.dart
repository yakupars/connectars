class Config {
  final String SERVER_HOST = '0.0.0.0';
  final String SERVER_PORT = '5555';
  final String SERVER_CERTIFICATE_CHAIN_PATH = '/path/to/fullchain.pem/file';
  final String SERVER_PRIVATE_KEY_PATH = '/path/to/privkey.pem/file';

  final String SOCKET_TOKEN = '043a33f74f72fcae29bbf500deded817';
  final String SOCKET_PING_INTERVAL = '5';
  final String SOCKET_PING_RESPONSE_TIMEOUT = '3';
  final String SOCKET_LOG_PATH = '/tmp/log/connectars';

  final String API_BASE = 'http://127.0.0.1:8080/socket/v1';
  final String API_ROUTE_AUTH = '/user/init';
  final String API_ROUTE_AUTH_HEADER = 'x-api-token';
  final String API_ROUTE_MESSAGE = '/message/process';
  final String API_ROUTE_MESSAGE_PARAMETER = 'message';
}