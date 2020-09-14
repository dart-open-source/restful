import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'app.dart';
import 'dao.dart';

class Fetch {
  static Client get client => Client();
  var headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36'};

  Future<Map> getHome([int page = 1]) async {
    var url = 'http://173.249.13.154:8089/app/gethomepage';
    var body = {'user_id': '22851', 'fname': 'Alm', 'email': 'almpazel@gmail.com', 'mobile': '13817767174', 'address': 'Gjjvc ', 'token': '37e03b18c2162fdb57b5674c51f2f2c760a188e3137b08d8bb41ee65812c92c3', 'pID': 'b49bea37-23d9-4763-ba46-a01144e943ea', 'page': page, 'delivery_option': ' '};
    var key = File('build/gethomepage-$page.json');
    var res = '';
    if (key.existsSync()) {
      res = key.readAsStringSync();
    } else {
      var response = await client.post(url, headers: headers, body: jsonEncode(body));
      res = utf8.decode(response.bodyBytes);
      key.writeAsStringSync(res);
    }
    Map<String, dynamic> json = jsonDecode(res);
    return json;
  }

  static Future<void> homeGoods() async {
    App.init();
    await Dao.connect();

    for (var i = 1; i < 103; i++) {
      var res = await Fetch().getHome(i);
      if (res != null && res.containsKey('HomeData')) {
        var list = res['HomeData'];
        if (list is List) {
          var insert = 0;
          for (var element in list) {
            var post = Map<String, dynamic>.from(element);
            var info = await Dao.items.findOne(where.eq('id', post['id']));
            if (info == null) {
              insert++;
              await Dao.items.insert(post);
            }
          }
          print('list[$i]=${list.length} insert:$insert');
        }
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  static Future<void> itemimg()async {

    var url='http://173.249.13.154:8089/admin/itemimg/';

    var key = File('build/img/-o.html');
    if(!key.existsSync()){
      var res=await client.get(url);
      if(res.statusCode==200) {
        key.writeAsBytesSync(res.bodyBytes);
      }
    }
    var m=RegExp(
        r'<a href="(.*)">(.*)</a>',
        multiLine: true,
        caseSensitive: true
    ).allMatches(key.readAsStringSync()).toList().sublist(2);

    var i=0;
    var c=0;
    var t=m.length;

    print('t:$t');

    for(var e in m){
      var fi=e.group(1);
      var key = File('build/img/${fi}');
      if (!key.existsSync()) {
        var res=await client.get(url+fi);
        if(res.statusCode==200){
          i++;
          c++;
          key.writeAsBytesSync(res.bodyBytes);
        }
        if(i>10){
          print('per:${c/(t/100)}');
          i=0;
        }
      }
      await Future.delayed(Duration(seconds: 1));
    }

  }
}







void main() async {
  await Fetch.itemimg();
}
