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

  /// actions start stop restart available
  var pro = App.pro(arguments);
  if (!await pro.needRun()) return;

  App.init();
  await Api.start(routerMap, port: 30400);
}

```


Listening on http://0.0.0.0:4040/system/info


## Usage

```shell

$ dart lib/app.dart start

$ dart lib/app.dart stop

$ dart lib/app.dart restart

$ dart lib/app.dart status

```
....