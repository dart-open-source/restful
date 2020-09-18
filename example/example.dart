import 'dart:io';
import 'package:restful/restful.dart';
import 'api/SystemApi.dart';
import 'api/UserApi.dart';
export 'package:restful/restful.dart';

dynamic routerMap(HttpRequest request) {
  var action = request.uri.pathSegments.isNotEmpty ? request.uri.pathSegments.first : 'none';
  switch (action) {
    case 'user':
      return UserApi();
    case 'system':
      return SystemApi();
  }
  throw Exception('not defined Api.${action} !?@!@#@# ');
}

void main(List<String> arguments) async {

  var pro = App.pro(arguments);
  if (!await pro.needRun()) return;

  App.init();
  await Api.start(routerMap, port: 30400);
}
