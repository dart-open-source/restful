import 'dart:convert';
import 'dart:io';
import 'api/UserApi.dart';
import 'api/SystemApi.dart';

export 'dao.dart';
import 'dao.dart';
import 'src/restful.dart';
export 'src/restful.dart';
export 'package:mongo_dart/mongo_dart.dart';

Api routerMap(HttpRequest request) {
  switch (request.uri.pathSegments.first) {
    case 'user':
      return UserApi();
    case 'system':
      return SystemApi();
  }
  throw Exception('not defined Api.!?@!@#@# ');
}

final App = _App();

class _App {
  Map _config = {

  };

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
