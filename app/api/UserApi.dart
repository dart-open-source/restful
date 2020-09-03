import 'package:restful/restful.dart';

class UserApi extends Api {

  Map<String, kApiMethod> get allows => {
        'login': login,
        'register': register,
  };

  Map<String, kApiMethod> get blocks => {
        'info': info,
      };


  Future<dynamic> login() async {
    var map=await jsonData();

    //todo get info
    return Api.error(map);
  }

  Future<dynamic> register() async {
    //todo get info
    return Api.error('register');
  }

  Future<dynamic> info() async {
    //todo get info
    return Api.error('info');
  }

}
