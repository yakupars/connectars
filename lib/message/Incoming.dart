class Incoming {
  String _source;
  String _id;
  String _from;
  List<String> _to;
  String _verb;
  String _route;
  Map<String, String> _headers;
  Map<String, dynamic> _body;

  String get source => _source;

  String get id => _id;

  String get from => _from;

  List<String> get to => _to;

  String get verb => _verb;

  String get route => _route;

  Map<String, String> get headers => _headers;

  Map<String, dynamic> get body => _body;

  Incoming(this._source, this._id, this._from, this._to, this._verb, this._route, this._headers, this._body);

  Incoming.map(dynamic obj) {
    _source = obj['source'];
    _id = obj['id'];
    _from = obj['from'];
    _to = List<String>.from(obj['to']);
    _verb = obj['verb'];
    _route = obj['route'];
    _headers = Map<String, String>.from(obj['headers']);
    _body = Map<String, dynamic>.from(obj['body']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['source'] = _source;
    map['id'] = _id;
    map['from'] = _from;
    map['to'] = _to;
    map['verb'] = _verb;
    map['route'] = _route;
    map['headers'] = _headers;
    map['body'] = _body;

    return map;
  }
}
