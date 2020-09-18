import 'package:mongo_dart/mongo_dart.dart';

import 'app.dart';

final Dao = _Dao();

class _Dao {
  Db db;

  void init(String config) => db=Db(config);

  bool get _isDbOpen => db.state == State.OPEN || db.state == State.OPENING;

  Future connect() async {
    if (!_isDbOpen) await db.open();
  }

  Future close() async {
    try{
      await db.close();
    // ignore: empty_catches
    }catch(e){}
  }
}

