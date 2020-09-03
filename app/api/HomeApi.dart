
import 'package:restful/restful.dart';

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