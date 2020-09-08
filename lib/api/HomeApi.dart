import '../app.dart';

class HomeApi extends Api {
  @override
  Map<String, kApiMethod> get allows => {
    'list': list,
  };

  Future<dynamic> list() async {
    return {
      'audios': '',
    };
  }
}