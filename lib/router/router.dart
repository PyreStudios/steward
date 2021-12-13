import 'dart:io';

import 'package:steward/container/container.dart';
import 'package:steward/controllers/controller.dart';
import 'package:steward/controllers/controller_route_binding.dart';
import 'package:steward/middleware/middleware.dart';
import 'package:steward/router/response.dart';
import 'package:steward/router/request.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

export 'package:steward/router/response.dart';
export 'package:steward/router/request.dart';

enum HttpVerb {
  Connect,
  Delete,
  Get,
  Head,
  Options,
  Patch,
  Post,
  Put,
  Trace
}

typedef RequestCallback = Response Function(Request request);

abstract class RouteBinding {
  late HttpVerb verb;
  late String path;
  List<MiddlewareFunc> middleware = [];

  RouteBinding({required this.verb, required this.path, this.middleware = const []});

  Response process(Request request);
}

class _FunctionBinding extends RouteBinding {
  RequestCallback callback;

  _FunctionBinding({required verb, required path, required this.callback, middleware = const []}): super(verb: verb, path: path, middleware: middleware);

  @override
  Response process(Request request) {
    return callback(request);
  }
}


class Router {

  Container? container;
  List<RouteBinding> bindings = [];
  List<MiddlewareFunc> middleware = [];
  HttpServer? server;

  void setDIContainer(Container container) {
    this.container = container;
  }

  void connect(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const []}) =>
    _addBinding(path, HttpVerb.Connect, handler: handler, controller: controller, method: method, middleware: middleware);

  void delete(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const []}) =>
    _addBinding(path, HttpVerb.Delete, handler: handler, controller: controller, method: method, middleware: middleware);

  void get(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const[]}) =>
    _addBinding(path, HttpVerb.Get, handler: handler, controller: controller, method: method, middleware: middleware);

  void options(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const[]}) =>
    _addBinding(path, HttpVerb.Options, handler: handler, controller: controller, method: method, middleware: middleware);

  void patch(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const[]}) =>
    _addBinding(path, HttpVerb.Patch, handler: handler, controller: controller, method: method, middleware: middleware);

  void post(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const[]}) =>
    _addBinding(path, HttpVerb.Post, handler: handler, controller: controller, method: method, middleware: middleware);

  void put(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const[]}) =>
    _addBinding(path, HttpVerb.Put, handler: handler, controller: controller, method: method, middleware: middleware);

  void trace(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const[]}) =>
    _addBinding(path, HttpVerb.Trace, handler: handler, controller: controller, method: method, middleware: middleware);

  void head(String path, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const[]}) =>
    _addBinding(path, HttpVerb.Head, handler: handler, controller: controller, method: method, middleware: middleware);


  void _addBinding(String path, HttpVerb verb, {RequestCallback? handler, Controller? controller, String? method, List<MiddlewareFunc> middleware = const []}) {
    if (handler != null) {
      bindings.add(_FunctionBinding(verb: HttpVerb.Trace, path: path, callback: handler, middleware: middleware));
    } else if (controller != null && method != null) {
      bindings.add(ControllerRouteBinding(verb: verb, path: path, controller: controller, methodName: method, middleware: middleware));
    } else {
      throw Exception('Unable to add binding');
    }
  }

  /// forcibly shut down the server
  /// userful if the server is running in the background
  Future terminate() {
    return server!.close(force: true);
  }

  Future serveHTTP() async {
    var port = container?.make('@config.app.port') ?? 4040;
    server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      port,
    );

    print('Bound server to port ${port}');

    await for (HttpRequest request in server!) {
      var hasMatch = false;
      for (var i = 0; i < bindings.length; i++) {
        var params = <String>[];
        var regex = pathToRegExp(bindings[i].path, parameters: params);
        hasMatch = regex.hasMatch(request.uri.path);

        if (hasMatch) {
            var match = regex.matchAsPrefix(request.uri.path);
            if (match != null) {
              var pathParams = extract(params, match);
              var req = Request(request: request, pathParams: pathParams)..setContainer(container);

              // process router level middleware
              if (middleware.isNotEmpty) {
                middleware.forEach((element) {
                  element(req);
                });
              }

              // process binding level middleware
              if (bindings[i].middleware.isNotEmpty) {
                bindings[i].middleware.forEach((element) {
                  element(req);
                });
              }

              var response = bindings[i].process(req);
              _renderResponse(request, response);
              break;
          }
        }
      }

      if (!hasMatch) {
        var req = Request(request: request)..setContainer(container);
        // process router level middleware
        if (middleware.isNotEmpty) {
          middleware.forEach((element) {
            element(req);
          });
        }
        request.response.statusCode = 404;
      }

      await request.response.close();
    }
  }

  void _renderResponse(HttpRequest request, Response response) {
    request.response.headers.contentType = response.headers.contentType;
    request.response.headers.date = response.headers.date;
    request.response.write(response.body);
  }
}
