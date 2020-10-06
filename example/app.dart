import 'dart:io';
import 'package:restful/restful.dart';
export 'package:restful/restful.dart';
export 'package:alm/alm.dart';

/// import apis
import 'api/SystemApi.dart';
import 'api/UserApi.dart';
import 'package:pro/pro.dart';

dynamic routerMap(HttpRequest request) {
  var action = request.uri.pathSegments.isNotEmpty ? request.uri.pathSegments.first : 'none';
  switch (action) {
    case 'user':
      return UserApi();
  }
  return SystemApi();
}

void main(List<String> arguments) async {
  ///path setup
  Pro.path = '.restful/';

  /// actions start stop restart available
  if (!await Pro(arguments).checkAction()) return;

  await Api.start(routerMap, port: 4040);
}
