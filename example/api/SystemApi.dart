import '../app.dart';

class SystemApi extends Api {

  @override
  Map<String, kApiMethod> get allows => {'info': info,'none': none};

  Future<dynamic> info() async {
    return Alm.success({
      'version':'1.0.0',
    });
  }
  Future<dynamic> none() async {
    return Alm.success({
      'none':'1.0.0',
    });
  }




}
