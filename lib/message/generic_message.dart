class GenericMessage {
  String _id;
  String _from;
  List<String> _to;
  Map _data;

  String get id => _id;

  set id(String id) => _id = id;

  String get from => _from;

  set from(String from) => _from = from;

  List<String> get to => _to;

  set to(List<String> to) => _to = to;

  Map get data => _data;

  set data(Map data) => _data = data;

  GenericMessage(this._id, this._from, this._to, this._data);

  GenericMessage.map(Map<String, dynamic> obj) {
    _id = obj['_id'];
    _from = obj['from'];
    _to = obj['to'] != null ? List<String>.from(obj['to']) : [];
    _data = Map.from(obj['data']);
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['_id'] = _id;
    map['from'] = _from;
    map['to'] = _to;
    map['data'] = _data;

    return map;
  }
}
