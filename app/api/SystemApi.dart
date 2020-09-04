
import 'dart:convert';
import 'dart:io';

import 'package:restful/restful.dart';

class SystemApi extends Api {

  @override
  Map<String, kApiMethod> get allows => {'info': info,'version':version};

  Future<dynamic> info() async {
    return Api.success({
      'version':Api.version,
    });
  }
  Future<dynamic> version() async {
    var source=File('/www/wwwroot/mygrocers.com/app/version.json').readAsStringSync();
    return Api.success(jsonDecode(source));
  }
}
