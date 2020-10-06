import '../app.dart';

class SystemApi extends Api {

  @override
  Map<String, kApiMethod> get allows => {'info': info};

  Future<dynamic> info() async {
    return Alm.success({
      'version':'1.0.0',
    });
  }




}
