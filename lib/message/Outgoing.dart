class Outgoing {
  String _target;
  String _id;
  String _from;
  List<String> _to;
  dynamic _data;

  String get target => _target;

  String get id => _id;

  String get from => _from;

  List<String> get to => _to;

  dynamic get data => _data;

  Outgoing(this._target, this._id, this._from, this._to, this._data);

  Outgoing.map(dynamic obj) {
    _target = obj['target'];
    _id = obj['id'];
    _from = obj['from'];
    _to = List<String>.from(obj['to']);
    _data = obj['data'];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['target'] = _target;
    map['id'] = _id;
    map['from'] = _from;
    map['to'] = _to;
    map['data'] = _data;
    return map;
  }
}
