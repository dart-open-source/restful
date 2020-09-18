import 'dart:io';
import 'package:process_run/process_run.dart' as pr;
import 'app.dart';
import 'global.dart';

class Processor {
  final List<String> arguments;
  final String root;

  static String PROCESS_NAME = 'DART#RESTFUL#ALM';

  int _pidOld = -1;

  Processor(this.arguments, this.root);

  int pidOld([int r]) {
    var pidFile = App.file('.pid');
    if (r != null) {
      pidFile.writeAsStringSync(r.toString());
      return r;
    }
    return pidFile.existsSync() ? any2int(pidFile.readAsStringSync()) : -1;
  }

  Future<bool> isPidRunning(int id, {bool log = false}) async {
    if (id == -1) return false;
    var res = await pr.run('ps', ['-p', id.toString()]);
    var chou = res.stdout.toString().trim().split('\n');
    if (log) print(res.stdout.toString());
    if (chou.length >= 2) return true;
    return false;
  }

  Future<void> _start() async {
    print('Start...[$_pidOld]');
    if (await isPidRunning(_pidOld)) {
      print('already start at:$_pidOld');
    } else {
      var cmd = '$root/cli lib/app.dart ${PROCESS_NAME} $root/${timeymd()}'.replaceAll('//', '/');
      print('cmd:$cmd');
      var res = await pr.run('sh', cmd.split(' '));
      print('stdout:${res.stdout}');
      print('stderr:${res.stderr}');
      var o = 0;
      while (true) {
        print('...:${pidOld()}');
        await Future.delayed(Duration(seconds: 1));
        o++;
        if (o > 10) break;
        if (pidOld() != -1) break;
      }
      if (pidOld() != -1) {
        print('now start at:${pidOld()}');
      } else {
        print('start is failed!!!');
        await _stop();
      }
    }
  }

  Future<void> _stop() async {
    print('Stop...[$_pidOld]');
    if (await isPidRunning(_pidOld)) {
      await pr.run('kill', [_pidOld.toString()]);
      print('now stop at:$_pidOld');
    } else {
      print('already stop!');
    }
    pidOld(-1);
  }

  Future<void> _status() async {
    print('Status...[$_pidOld]');
    if (await isPidRunning(_pidOld, log: true)) {
      print('status:${_pidOld} is running;');
    } else {
      print('status:${_pidOld} is stop;');
    }
  }

  Future<bool> needRun() async {
    var action = arguments.isNotEmpty ? arguments.first : PROCESS_NAME;
    _pidOld = pidOld();
    if (action == 'start') await _start();

    if (action == 'stop') await _stop();

    if (action == 'restart') {
      await _stop();
      await Future.delayed(Duration(seconds: 3));
      await _start();
    }

    if (action == 'status') await _status();

    if (action == PROCESS_NAME) {
      print('Run...[$_pidOld]');
      if (await isPidRunning(_pidOld)) {
        print('already running at:${_pidOld}');
      } else {
        pidOld(pid);
        print('currently run at:$pid');
        return true;
      }
    }
    return false;
  }
}
