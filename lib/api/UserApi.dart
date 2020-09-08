import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:restful/global.dart';

import '../app.dart';

class UserApi extends Api {
  Map<String, kApiMethod> get allows => {
        'login': login,
        'register': register,
      };

  Map<String, kApiMethod> get blocks => {
        'info': info,
      };

  Future<dynamic> login() async {
    var map = await jsonData();
    try {
      if (map.containsKey('name') && map.containsKey('pass')) {
        var whereQ = where.eq('name', map['name'].toString());
        await Dao.connect();
        var info = await Dao.user.findOne(whereQ);
        if (info == null) throw Exception('not fund user');
        if (info['pass'] != map['pass']) throw Exception('not fund user');

        info['token'] = tokenGen(info);
        info['request'] = requestInfo;

        map.forEach((key, value) {
          info[key] = value;
        });

        await Dao.user.update(whereQ, info);
        return Api.success({'token': info['token']});
      }
    } catch (e) {
      return Api.error(e.toString());
    }
    return Api.error('data error');
  }

  Future<dynamic> register() async {
    var map = await jsonData();
    try {
      if (map.containsKey('name') && map.containsKey('pass')) {
        var whereQ = where.eq('name', map['name'].toString());
        await Dao.connect();
        var info = await Dao.user.findOne(whereQ);
        if (info != null) throw Exception('already registered this account');
        map['token'] = tokenGen(map);
        map['request'] = requestInfo;
        await Dao.user.insert(map);
        return Api.success({'token': map['token']});
      }
    } catch (e) {
      return Api.error(e.toString());
    }
    return Api.error('data error');
  }

  Future<dynamic> info() async {
    //todo get info
    return Api.error('info');
  }

  String tokenGen(Map info) {
    info['time'] = timedate();
    return base64Encode('${info['time']}:${info['name']}=${info['pass']}'.codeUnits);
  }
}
