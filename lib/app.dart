import 'package:restful/restful.dart';

import 'api/HomeApi.dart';
import 'api/PubApi.dart';
import 'api/UserApi.dart';
import 'api/SystemApi.dart';


export 'dao.dart';
import 'restful.dart';
export 'restful.dart';


final RouteMap = {
  'user': UserApi(),
  '/': HomeApi(),
  'system': SystemApi(),
  'pub': PubApi(),
};

void main(List<String> arguments) async {
  await Api.start(RouteMap,port: 30400);
}

final App = _App();

class _App {

}
