import 'dart:convert';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:alm/alm.dart';

typedef kApiMethod = Future<dynamic> Function();
typedef kPostMethod = bool Function(Map);
typedef kRouteMethod = dynamic Function(HttpRequest);

abstract class _Api {
  HttpRequest request;

  Map<String, kApiMethod> allows = {};
  Map<String, kApiMethod> blocks = {};

  Future<void> init();

  String get headerToken => request?.headers?.value('token');

  Future<bool> headerCheckToken();
}

class Api implements _Api {

  /// Use [Alm.error] instead
  @deprecated
  static Map error(dynamic s, {dynamic msg = 'error'}) => Alm.error(s,msg: msg);

  /// Use [Alm.success] instead
  @deprecated
  static Map success(dynamic s, {dynamic msg = 'success'}) => Alm.success(s,msg: msg);

  static String generateToken(String pass, {Duration duration}) => Alm.tokenGen(pass, duration: duration);
  static bool expiredToken(String token, {Duration duration}) => Alm.tokenExpired(token);
  static Map decodeToken(String token) => Alm.tokenDecode(token);

  dynamic postData;
  Map postJson;
  Map user={};

  bool get isGet => method == 'GET';

  bool get isPost => method == 'POST';

  String get method => request.method??'GET';

  bool get isBoundary => contentType.parameters.containsKey('boundary');

  ContentType get contentType => request.headers.contentType;

  List<String> get arguments=>request.uri.pathSegments;

  @override
  Future<void> init() {}

  Map get requestInfo {
    dynamic map = {};
    map['ip'] = '${request.connectionInfo.remoteAddress.host}:${request.connectionInfo.remotePort}';
    map['header'] = '${request.headers}';
    map['time'] = Alm.timedate();
    return map;
  }

  Future<String> enter(HttpRequest request) async {
    this.request = request;
    var pathSegments = request.requestedUri.pathSegments;
    var action = pathSegments.last;
    dynamic res;


    try {
      if (isPost && contentType.mimeType.toLowerCase()==ContentType.json.mimeType.toLowerCase()) {
        postJson = jsonDecode(await utf8.decoder.bind(request).join());
      }

      if (blocks.containsKey(action)) {
        if (await headerCheckToken()){
          res=Alm.error('token expired or need re login!');
        }else{
          await init();
          res = await blocks[action]();
        }
      } else if (allows.containsKey(action)) {
        await init();
        res = await allows[action]();
      } else {
        res = Alm.error('$action not found in [$runtimeType]');
      }

    } catch (e) {
      res=Alm.error('Data?! json decode error');
    }

    return jsonEncode(res);
  }

  Future<Map> postMultiPart([Map<String, kPostMethod> listFiles]) async {
    Map<String, dynamic> postM;
    var _listFiles = listFiles ?? {};
    try {
      if (isBoundary) {
        var boundary = contentType.parameters['boundary'];
        var rs = MimeMultipartTransformer(boundary).bind(request);
        postM = {};
        await rs.forEach((element) async {
          try {
            if (element.headers.containsKey('content-disposition')) {
              var mp = Alm.fromDataDecode(element.headers['content-disposition']);
              if (mp.containsKey('name')) {
                var name = mp['name'];
                if (mp.length == 1) {
                  postM[name] = await utf8.decoder.bind(element).join();
                } else {
                  if (_listFiles.containsKey(name)) {
                    postM[name] = <String, dynamic>{};
                    mp.forEach((key, value) {
                      postM[name][key] = value;
                    });
                    element.headers.forEach((key, value) {
                      postM[name][key] = value;
                    });
                    if (_listFiles[name](postM[name])) {
                      var byteList = await element.toList();
                      var bytes = <int>[];
                      byteList.forEach((iterable) {
                        bytes.addAll(iterable);
                      });
                      postM[name]['bytes'] = bytes;
                    }
                  } else {
                    postM[name] = <String, dynamic>{};
                    mp.forEach((key, value) {
                      postM[name][key] = value;
                    });
                  }
                }
              }
            }
          } catch (e) {
            print('Api.postMultiPart error $e ${element.headers}');
          }
        });
        if(postM.isEmpty) postM=null;
      }
    } catch (e) {
      print('Api.postMultiPart error $e');
      postM = null;
    }
    return postM;
  }

  static void start(kRouteMethod routeMap, {int port = 4040, Future<void> onStart, Future<void> onClose, Function onUpdate,Map<String,String> responseHeaders}) async {
    var server = await HttpServer.bind('0.0.0.0', port);
    if (onStart != null) await onStart;

    print('Listening on http://${server.address.host}:${server.port}/');

    var _responseHeaders=responseHeaders??{
      'Access-Control-Allow-Origin':'*',
      'Access-Control-Allow-Methods':'*',
      'Access-Control-Allow-Headers':'*',
    };

    await for (HttpRequest request in server) {
      if (onUpdate != null) onUpdate();

      var reqMsg = '${request.method} ${request.requestedUri}(${request.contentLength})';

      var response = request.response;

      dynamic err;

      try {
        _responseHeaders.forEach((key, value) {
          response.headers.add(key, value);
        });
        response.headers.add('Server', 'Dart-Restful:1.0.0;Author:almpazel@gmail.com;Date:2020-2025;');
        String resBody;
        response.statusCode = HttpStatus.processing;
        try {
          response.headers.contentType=ContentType.json;
          var rs=routeMap(request);
          if(rs is Api){
            resBody = await rs.enter(request);
          }else{
            if(rs is String){
              resBody = rs;
            }else{
              resBody = rs.toString();
            }
          }
          response.statusCode = HttpStatus.ok;
        } catch (e) {
          err = e;
          response.statusCode = HttpStatus.internalServerError;
          resBody = jsonEncode(Alm.error(e.toString()));
        }
        if(resBody!=null) response.write(resBody);
        await response.close();

        print('${Alm.timestamp()} $reqMsg -> ${response.statusCode} (${response.contentLength}) ${err != null ? 'error:$err' : ''} ');
      } catch (e) {
        print('error:$e');
      }
    }
    if (onClose != null) await onClose;
  }

  @override
  Map<String, kApiMethod> allows = {};

  @override
  Map<String, kApiMethod> blocks = {};

  @override
  HttpRequest request;

  @override
  String get headerToken => request?.headers?.value('token');

  @override
  Future<bool> headerCheckToken() async => true;
}
