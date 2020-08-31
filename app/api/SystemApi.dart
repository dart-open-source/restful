
import 'package:restful/restful.dart';

class SystemApi extends Api {

  @override
  Map<String, kApiMethod> get allows => {'info': info};

  Future<dynamic> info() async {
    return Api.success({
      'version':Api.version,
    });
  }
}
