import 'package:mongo_dart/mongo_dart.dart';

import 'app.dart';

final Dao = _Dao();

class _Dao {
  Db db;

  void init() async {
    db = Db(App.config['mongodb'].toString());
  }

  bool get _isDbOpen => db.state == State.OPEN || db.state == State.OPENING;
  DbCollection get user => db.collection('user');

  Future connect() async {
    if (!_isDbOpen) await db.open();
  }

  Future<Map> log(Map map, [String s = 'api']) => db.collection('log').insert({'type': s, 'data': map});

  Future close() async {
    try{
      await db.close();
    }catch(e){}
  }
}

