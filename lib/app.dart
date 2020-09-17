import 'dart:convert';
import 'dart:io';
import 'package:restful/restful.dart';

import 'dao.dart';
import 'src/processor.dart';
export 'package:restful/restful.dart';

final App = _App();

class _App {
  Map _config = {};

  void init() async {
    print('init:${config}');
    Dao.init();
  }

  Map get config {
    var fileConfig = File('.config.json');
    if (fileConfig.existsSync()) {
      _config = jsonDecode(fileConfig.readAsStringSync());
    }
    return _config;
  }

  DbCollection db(String s) => Dao.db.collection(s);

  Processor pro(List<String> arguments) => Processor(arguments);

  Future connect() async => await Dao.connect();
}
