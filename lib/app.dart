import 'dart:convert';
import 'dart:io';
import 'package:restful/restful.dart';
import 'package:restful/src/global.dart';
import 'package:restful/src/tempCon.dart';

import 'dao.dart';
import 'src/processor.dart';
export 'package:restful/restful.dart';

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

    if (File('.gitignore').existsSync()) {
      var liens = File('.gitignore').readAsLinesSync();
      if (!liens.contains(path)) {

        var ignoreInfo=[
          '',
          '#$path at ${timestampStr()}',
          path,
          '',
        ];
        File('.gitignore').writeAsStringSync(ignoreInfo.join('\n'), mode: FileMode.append);
      }
    }

    if (!file('cli').existsSync()) {
      file('cli').writeAsStringSync(tempCli.replaceAll('#head#', '#${timestampStr()}'));
    }

    Dao.init();
  }

  Map get config {
    var fileConfig = file('.config.json');
    if (fileConfig.existsSync()) {
      _config = jsonDecode(fileConfig.readAsStringSync());
    }
    return _config;
  }

  DbCollection db(String s) => Dao.db.collection(s);

  Processor pro(List<String> arguments) => Processor(arguments,path);

  Future connect() async => await Dao.connect();
}
