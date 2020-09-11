import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:restful/global.dart';

typedef kApiMethod = Future<dynamic> Function();
typedef kRouteMethod = Api Function(Uri);

abstract class _Api {
  HttpRequest request;

  String get token;

  Map<String, kApiMethod> allows = {};
  Map<String, kApiMethod> blocks = {};

  void init();

  @mustCallSuper
  Future<dynamic> enter(HttpRequest request, Map post);

  Future<bool> tokenExpired();
}

class Api implements _Api {
  static var version = '0.0.1';

  Map post;

  bool postKeyVal(String val,[String key='type']) => postKey(key)&&post[key]==val;
  bool postKey(String key) => post!=null&&post.containsKey(key);
  bool get isGet => request.method=='GET';
  bool get isPost => request.method=='POST';

  @override
  void init() {}

  Map get requestInfo {
    dynamic map = {};
    map['ip'] = '${request.connectionInfo.remoteAddress.host}:${request.connectionInfo.remotePort}';
    map['header'] = '${request.headers}';
    map['time'] = timedate();
    return map;
  }

  @override
  Future<dynamic> enter(HttpRequest request, Map post) async {
    this.request = request;
    this.post = post;
    var pathSegments = request.requestedUri.pathSegments;
    var action = pathSegments.last;
    dynamic res;
    if (blocks.containsKey(action)) {
      if (await tokenExpired()) return Api.errorToken();
      await init();
      res=await blocks[action]();
    } else if (allows.containsKey(action)) {
      await init();
      res=await allows[action]();
    } else {
      res=error('$action not found in [$runtimeType]');
    }
    return jsonEncode(res);
  }

  static Map error(dynamic s, {dynamic msg = 'error'}) {
    return {'msg': msg, 'code': -1, 'result': s};
  }

  static Map errorToken() {
    return error('token expired or need re login!');
  }

  static Map success(dynamic s, {dynamic msg = 'success'}) {
    return {'msg': msg, 'code': 1, 'result': s};
  }

  @override
  Future<bool> tokenExpired() async {
    if (token == null) return true;
    return false;
  }

  static void start(kRouteMethod routeMap, {int port = 4040, Future<void> onStart, Future<void> onClose, Function onUpdate}) async {
    var server = await HttpServer.bind('0.0.0.0', port);
    if (onStart != null) await onStart;
    print('Listening on http://${server.address.host}:${server.port}/system/info');
    await for (HttpRequest request in server) {
      if (onUpdate != null) onUpdate();

      var reqMsg='${request.method} ${request.requestedUri}(${request.contentLength})';

      var response = request.response;

      dynamic err;

      try {
        response.headers.contentType = ContentType.json;
        response.headers.add('Access-Control-Allow-Origin', '*');
        response.headers.add('Access-Control-Allow-Methods', '*');
        response.headers.add('Server', 'Dart-RestFul ${Api.version}');
        String resBody;
        try {
          if (request.method == 'POST' || request.method == 'GET') {
            Map post;
            if (request.method == 'POST') {
              try{
                post = jsonDecode(await utf8.decoder.bind(request).join());
              }catch(e){
                post=null;
              }
            }
            final api = routeMap(request.requestedUri);
            resBody = await api.enter(request, post);
            response.statusCode = HttpStatus.ok;
          } else {
            throw Exception('Unsupported request: ${request.method}.');
          }
        } catch (e) {
          err=e;
          response.statusCode = HttpStatus.internalServerError;
          resBody = jsonEncode(Api.error(e.toString()));
        }
        response.write(resBody);
        await response.close();

        print('${timestamp()} $reqMsg -> ${response.statusCode} (${response.contentLength}) ${err!=null?'error:$err':''} ');

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
  String get token => request?.headers?.value('token');
}
