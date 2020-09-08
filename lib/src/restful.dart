import 'dart:convert';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:mongo_dart/mongo_dart.dart';

typedef kApiMethod = Future<dynamic> Function();

abstract class _Api {
  HttpRequest request;
  String action;
  kApiMethod onActionNull;
  String get token;
  List<String> arguments = [];
  Map<String, kApiMethod> allows = {};
  Map<String, kApiMethod> blocks = {};
  void init();
  @mustCallSuper
  Future<dynamic> enter(HttpRequest request);
  Future<bool> tokenExpired();
}

class Api implements _Api {
  static var version='0.0.1';

  @override
  void init() {}

  Future<Map<String,dynamic>> jsonData() async {
    try {
      dynamic map = {};
      await request.listen((event) {
        map = jsonDecode(utf8.decode(event));
      });
      map['create_at']=DateTime.now();
      map['ip']='${request.connectionInfo.remoteAddress.host}:${request.connectionInfo.remotePort}';
      map['header']='${request.headers}';
      return Map.from(map);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<dynamic> enter(HttpRequest request) async {
    this.request = request;
    var pathSegments = request.requestedUri.pathSegments;
    arguments = pathSegments.getRange(1, pathSegments.length - 1).toList();
    action = pathSegments.last;

    if (blocks.containsKey(action)) {
      if (await tokenExpired()) return Api.errorToken();
      await init();
      return await blocks[action]();
    } else if (allows.containsKey(action)) {
      await init();
      return await allows[action]();
    } else {
      return _actionNotFound;
    }
  }

  Map get _actionNotFound => {'error': '$action not found in [$runtimeType]'};

  static Map error(dynamic s,{dynamic msg='error'}) {
    return {'msg': msg,'code': -1, 'data': s};
  }

  static Map errorToken() {
    return error('token expired or need re login!');
  }

  static Map success(dynamic s,{dynamic msg='success'}) {
    return {'msg': msg,'code': 1, 'data': s};
  }

  @override
  Future<bool> tokenExpired() async {
    if (token == null) return true;
    return false;
  }

  static void start(Map<String, Api> routeMap, {int port=4040,Future<void> onStart, Future<void> onClose, Function onUpdate}) async {
    var server = await HttpServer.bind('0.0.0.0', port);
    if (onStart != null) await onStart;
    print('Listening on http://${server.address.host}:${server.port}/system/info');
    await for (HttpRequest request in server) {
      if (onUpdate != null) onUpdate();
      request.response.headers.contentType = ContentType.json;
      request.response.headers.add('Access-Control-Allow-Origin', '*');
      request.response.headers.add('Access-Control-Allow-Methods', '*');
      request.response.headers.add('Server', 'Dart-RestFul ${Api.version}');
      var json = '{}';
      try {
        var res = {};
        final route = request.requestedUri.pathSegments.first;
        final api = routeMap[route];
        if (api != null) res = await api.enter(request);
        print('method:${request.method} requestedUri:${request.requestedUri} contentLength:${request.contentLength} ');
        json = jsonEncode(res);
      } catch (e) {
        json = jsonEncode(Api.error(e.toString()));
      }
      request.response.write(json);
      await request.response.close();
    }
    if (onClose != null) await onClose;
  }

  @override
  String action;

  @override
  Map<String, kApiMethod> allows={};

  @override
  List<String> arguments=[];

  @override
  Map<String, kApiMethod> blocks={};

  @override
  kApiMethod onActionNull;

  @override
  HttpRequest request;

  @override
  String get token => request?.headers?.value('token');
}
