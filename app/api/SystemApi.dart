
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
    return Api.success({
      "version_code": "1.1.2",
      "version_name": "debug",
      "update_content": "debug new version",
      "package_url": "http://mygrocers.org/app/release.apk",
      "is_required": 0,
      "size": 27613472,
      "update_ids": ""
    });
  }
}
