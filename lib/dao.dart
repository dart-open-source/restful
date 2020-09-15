import 'package:mongo_dart/mongo_dart.dart';
import 'app.dart';

final Dao = _Dao();

class _Dao {
  Db db;

  void init() async {
    db = Db(App.config['mongodb'].toString());
  }

  bool get _isDbOpen => db.state == State.OPEN || db.state == State.OPENING;
  DbCollection get loginLog => db.collection('loginLog');
  DbCollection get user => db.collection('user');
  DbCollection get category => db.collection('category');
  DbCollection get product => db.collection('product');
  DbCollection get feedback => db.collection('feedback');
  DbCollection get order => db.collection('order');
  DbCollection get items => db.collection('items');

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

