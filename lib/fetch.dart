

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'app.dart';
import 'dao.dart';

class Fetch{

  Client get client=>Client();
  var headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.163 Safari/537.36'};


  Future<Map> getHome([int page=1]) async {
    var url='http://173.249.13.154:8089/app/gethomepage';
    var body={
      'user_id': '22851',
      'fname': 'Alm',
      'email': 'almpazel@gmail.com',
      'mobile': '13817767174',
      'address': 'Gjjvc ',
      'token': '37e03b18c2162fdb57b5674c51f2f2c760a188e3137b08d8bb41ee65812c92c3',
      'pID': 'b49bea37-23d9-4763-ba46-a01144e943ea',
      'page': page,
      'delivery_option': ' '
    };
    var key=File('build/gethomepage-$page.json');
    var res='';
    if(key.existsSync()){
      res=key.readAsStringSync();
    }else{
      var response = await client.post(url, headers: headers,body: jsonEncode(body));
      res=utf8.decode(response.bodyBytes);
      key.writeAsStringSync(res);
    }
    Map<String, dynamic> json = jsonDecode(res);
    return json;
  }
}

void main()async{
  App.init();
  await Dao.connect();
  for(var i=1;i<103;i++){
    var res=await Fetch().getHome(i);
    if(res!=null&&res.containsKey('HomeData')){
      var list=res['HomeData'];
      if(list is List) {

        var insert=0;
        for(var element in list){
          var post=Map<String,dynamic>.from(element);
          var info = await Dao.items.findOne(where.eq('id', post['id']));
          if(info==null){
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