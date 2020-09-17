import '../app.dart';

class UserApi extends Api {
  @override
  Map<String, kApiMethod> get allows => {
    'login': login,
    'register': register,
  };

  @override
  Map<String, kApiMethod> get blocks => {
    'info': info,
  };

  Future<dynamic> login() async {
    if (postJson != null && postJson.containsKey('name') && postJson.containsKey('pass')) {
      var whereQ = where.eq('name', postJson['name'].toString());
      await Dao.connect();
      var info = await Dao.user.findOne(whereQ);
      if (info == null) throw Exception('not fund user');
      if (info['pass'] != postJson['pass']) throw Exception('not fund user');

      info['token'] = Api.generateToken([postJson['name'], postJson['pass']].join('='));
      info['request'] = requestInfo;

      postJson.forEach((key, value) {
        info[key] = value;
      });

      await Dao.user.update(whereQ, info);
      return Api.success({'token': info['token']});
    }
    return Api.error('data error');
  }

  Future<dynamic> register() async {
    if (postJson != null && postJson.containsKey('name') && postJson.containsKey('pass')) {
      var whereQ = where.eq('name', postJson['name'].toString());
      await Dao.connect();
      var info = await Dao.user.findOne(whereQ);
      if (info != null) throw Exception('already registered this account');
      postJson['token'] = Api.generateToken([postJson['name'], postJson['pass']].join('='));
      postJson['request'] = requestInfo;
      await Dao.user.insert(postJson);
      return Api.success({'token': postJson['token']});
    }
    return Api.error('data error');
  }

  Future<dynamic> info() async {
    //todo get info
    return Api.error('info');
  }
}
