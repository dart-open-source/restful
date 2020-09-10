import 'dart:convert';
import 'dart:io';

import 'package:restful/restful.dart';

import 'api/BaseApi.dart';
import 'api/UserApi.dart';
import 'api/SystemApi.dart';

export 'dao.dart';
import 'dao.dart';
import 'restful.dart';
export 'restful.dart';

Api routerMap(Uri uri) {
  switch (uri.pathSegments.first) {
    case 'user':
      return UserApi();
    case 'system':
      return SystemApi();
  }
  return BaseApi();
}

final App = _App();

class _App {
  Map _config = {'mongodb': 'mongodb://127.0.0.1:27017/test'};

  void init() async {
    print('init:${config}');
    Dao.init();
  }

  Map get config {
    var fileConfig = File('.config.json');
    if (fileConfig.existsSync()) {
      _config = jsonDecode(fileConfig.readAsStringSync());
    }
    return _config;
  }
}

void main(List<String> arguments) async {
  App.init();
  await Api.start(routerMap, port: 30400);
}
