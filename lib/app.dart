import 'dart:convert';
import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';

import 'global.dart';
import 'restful_iml.dart';
import 'tempCon.dart';
import 'dao.dart';
import 'processor.dart';

final App = _App();

class _App {
  Map _config = {};

  static String path = '.restful/';

  File file(String s) {
    if (!Directory(path).existsSync()) Directory(path).createSync();
    return File([path, s].join());
  }

  void init() async {
    print('init:${config}');

    gitIgnoreUpdate(path);

    if (!file('cli').existsSync()) {
      file('cli').writeAsStringSync(tempCli.replaceAll('#head#', '#${timestampStr()}'));
    }
    if(config.containsKey('mongodb')) {
      Dao.init(config['mongodb']);
    }
  }

  Map get config {
    var fileConfig = file('.config.json');
    if (fileConfig.existsSync()) {
      _config = jsonDecode(fileConfig.readAsStringSync());
    }
    return _config;
  }

  DbCollection db(String collection) => Dao.db.collection(collection);

  Processor pro(List<String> arguments) => Processor(arguments,path);

  Future connect() async => await Dao.connect();

  void start(kRouteMethod routerMap, {int port}) async =>Api.start(routerMap,port: port);


}
