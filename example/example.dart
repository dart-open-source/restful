import 'package:restful/restful.dart';
export 'package:restful/restful.dart';
export 'package:alm/alm.dart';

import 'app.dart';

void main(List<String> arguments) async {
  ///
  await Api.start((req) {
    return Alm.success('hello world');
  }, port: 4040);
}
