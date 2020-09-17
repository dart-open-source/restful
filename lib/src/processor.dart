import 'dart:io';
import 'package:process_run/process_run.dart' as pr;
import 'global.dart';


class Processor{
  List<String> arguments;

  static String PROCESS_NAME='DART#RESTFUL#ALM';

  Processor(this.arguments);

  int pidOld([int r]){
    var pidFile=File('.pid');
    if(r!=null){
      pidFile.writeAsStringSync(r.toString());
      return r;
    }
    return pidFile.existsSync()?any2int(pidFile.readAsStringSync()):-1;
  }


  Future<bool> isPidRunning(int id, {bool log=false})async{
    if(id==-1) return false;
    var res=await pr.run('ps', ['-p',id.toString()]);
    var chout=res.stdout.toString().trim().split('\n');
    if(log) print(res.stdout.toString());
    if(chout.length>=2) return true;
    return false;
  }


  Future<bool> needRun() async{
    var action=arguments.isNotEmpty?arguments.first:PROCESS_NAME;
    var _pidOld=pidOld();
    if(action=='start'){
      print('Start...');
      if(await isPidRunning(_pidOld)){
        print('already start at:$_pidOld');
      }else{
        var cmd='cli run ${PROCESS_NAME} ${timeymd()}';
        print('cmd:$cmd');
        var res=await pr.run('sh',cmd.split(' '));
        var o=0;
        while(true){
          print('...:${pidOld()}');
          await Future.delayed(Duration(seconds: 1));
          o++;
          if(o>30) break;
          if(pidOld()!=-1) break;
        }
        if(pidOld()!=-1){
          print('now start at:${pidOld()}');
        }else{
          action='stop';
        }
      }
    }

    if(action=='stop'){
      print('Stop...');
      if(await isPidRunning(_pidOld)){
        await pr.run('kill',[_pidOld.toString()]);
        print('now stop at:$_pidOld');
      }else{
        print('already stop!');
      }
      pidOld(-1);
    }

    if(action=='status'){
      print('Status...');
      if(await isPidRunning(_pidOld,log:true)){
        print('status:${_pidOld} is running;');

      }else{
        print('status:${_pidOld} is stoped;');
      }
    }

    if(action==PROCESS_NAME){
      print('Run...');
      if(await isPidRunning(_pidOld)){
        print('already running at:${_pidOld}');
      }else{
        pidOld(pid);
        print('currently run at:$pid');
        return true;
      }
    }
    return false;
  }
}

