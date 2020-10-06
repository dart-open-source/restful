A RestFul Api library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://gitee.com/darto/restful/blob/master/LICENSE).

## Usage
restful api for small things...


your app.dart file example:

```dart

import 'package:restful/restful.dart';

//Change routes and actions

/// import apis
import 'api/SystemApi.dart';
import 'api/UserApi.dart';


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
  App.init();
  await Api.start(routerMap, port: 4040);
}

```

Listening on http://127.0.0.1:4040/

## Usage for Background Mode [Here](https://pub.dev/packages/pro).

- import pro lib to main.dart

```dart
import 'package:pro/pro.dart';

void main(List<String> arguments) async {
  
  if (!await Pro(arguments).checkAction()) return;
  
  App.init();
  await Api.start(routerMap, port: 4040);
}

```

- for command line

```shell

$ dart example/app.dart
$ dart example/app.dart start
$ dart example/app.dart stop
$ dart example/app.dart restart
$ dart example/app.dart status

```
....