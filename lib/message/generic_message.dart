class GenericMessage {
  String _id;
  String _type;
  String _from;
  List<String> _to;
  dynamic _data;

  String get id => _id;

  String get type => _type;

  String get from => _from;

  List<String> get to => _to;

  dynamic get data => _data;

  GenericMessage(this._id, this._type, this._from, this._to, this._data);

  GenericMessage.map(dynamic obj) {
    _id = obj['_id'];
    _type = obj['_type'];
    _from = obj['from'];
    _to = List<String>.from(obj['to']);
    _data = obj['data'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['_id'] = _id;
    map['_type'] = _type;
    map['from'] = _from;
    map['to'] = _to;
    map['data'] = _data;

    return map;
  }
}
