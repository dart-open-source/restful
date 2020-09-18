A RestFul Api library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://gitee.com/almpazel/dart-restful/blob/master/LICENSE).

## Usage
restful api for small things...


```dart
import 'package:restful/restful_iml.dart';

//Change routes and actions
  
final RouteMap = {
  'user': UserApi(),
  '/': HomeApi(),
  'system': SystemApi(),
  'pub': PubApi(),
};

void main(List<String> arguments) async {
  await Api.start(RouteMap,post:4040);
}
```


Listening on http://0.0.0.0:4040/system/info


## References

....