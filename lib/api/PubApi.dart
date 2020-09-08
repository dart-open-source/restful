import '../app.dart';

class PubApi extends Api {

  @override
  Map<String, kApiMethod> get blocks => {'apply': apply};

  Future<dynamic> apply() async {

    return Api.success(post);
  }
}
