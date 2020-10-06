
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
    if (Alm.isMap(postJson,['name','pass'])) {

      //todo check user

      var info = {};
      info['token'] = Api.generateToken([postJson['name'], postJson['pass']].join('='));
      info['request'] = requestInfo;
      postJson.forEach((key, value) {
        info[key] = value;
      });
      return Alm.success(info);
    }
    return Alm.error('data error');
  }

  Future<dynamic> register() async {
    if (Alm.isMap(postJson,['name','pass'])) {
      //todo check user

      var info = {};
      info['token'] = Api.generateToken([postJson['name'], postJson['pass']].join('='));
      info['request'] = requestInfo;
      postJson.forEach((key, value) {
        info[key] = value;
      });
      return Alm.success(info);
    }
    return Alm.error('data error');
  }

  Future<dynamic> info() async {

    //todo get info

    return Alm.error('info');
  }
}
