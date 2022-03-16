import 'dart:io';
import 'dart:math';
import 'dart:mirrors';

import 'package:steward/container/container.dart';
import 'package:steward/controllers/controller.dart';
import 'package:steward/controllers/route_utils.dart';
import 'package:steward/middleware/middleware.dart';
import 'package:steward/router/response.dart';
import 'package:steward/router/request.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:steward/steward.dart';

export 'package:steward/router/response.dart';
export 'package:steward/router/request.dart';

enum HttpVerb { Connect, Delete, Get, Head, Options, Patch, Post, Put, Trace }
typedef RequestCallback = Future<Response> Function(Request request);

abstract class Processable {
  Future<Response> process(Request request);
}

abstract class RouteBinding implements Processable {
  late HttpVerb verb;
  late String path;
  List<MiddlewareFunc> middleware = [];

  RouteBinding(
      {required this.verb, required this.path, this.middleware = const []});
}

class _FunctionBinding extends RouteBinding {
  RequestCallback callback;

  _FunctionBinding(
      {required verb,
      required path,
      required this.callback,
      middleware = const []})
      : super(verb: verb, path: path, middleware: middleware);

  @override
  Future<Response> process(Request request) {
    return callback(request);
  }
}

class Router {
  Container container = CacheContainer();
  List<RouteBinding> bindings = [];
  List<MiddlewareFunc> middleware = [];
  HttpServer? server;
  dynamic address = InternetAddress.ANY_IP_V4;

  Router({this.address});

  void setDIContainer(Container container) {
    this.container = container;
  }

  void mount(Type controllerType) {
    final controllerDeclaration = reflectClass(controllerType);
    final paths = getPaths(controllerDeclaration);
    paths.forEach((element) {
      bindings.add(_FunctionBinding(
          verb: element.verb,
          path: element.path,
          callback: controllerItemRouteHandler(controllerType, element.method),
          middleware: middleware));
    });
  }

  void connect(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Connect, handler, middleware: middleware);

  void delete(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Delete, handler, middleware: middleware);

  void get(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Get, handler, middleware: middleware);

  void options(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Options, handler, middleware: middleware);

  void patch(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Patch, handler, middleware: middleware);

  void post(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Post, handler, middleware: middleware);

  void put(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Put, handler, middleware: middleware);

  void trace(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Trace, handler, middleware: middleware);

  void head(String path, RequestCallback handler,
          {List<MiddlewareFunc> middleware = const []}) =>
      _addBinding(path, HttpVerb.Head, handler, middleware: middleware);

  void _addBinding(String path, HttpVerb verb, RequestCallback handler,
      {List<MiddlewareFunc> middleware = const []}) {
    bindings.add(_FunctionBinding(
        verb: HttpVerb.Trace,
        path: path,
        callback: handler,
        middleware: middleware));
  }

  /// forcibly shut down the server
  /// userful if the server is running in the background
  Future terminate() {
    return server!.close(force: true);
  }

  Future serveHTTP() async {
    var port = container.make('@config.app.port') ?? 4040;
    server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      port,
    );

    print('Bound server to port $port');

    await for (HttpRequest request in server!) {
      var hasMatch = false;
      for (var i = 0; i < bindings.length; i++) {
        var params = <String>[];

        // Get the root pattern from the pathToRegex call
        var rootPattern =
            pathToRegExp(bindings[i].path, parameters: params).pattern;
        // Build a new regex by removing the $, adding in the optional trailing slash
        // and then adding the end terminator back on ($).
        var regex = RegExp(
            '${rootPattern.substring(0, rootPattern.length - 1)}\\/?\$',
            caseSensitive: false);
        hasMatch = regex.hasMatch(request.uri.path);

        if (hasMatch) {
          // TODO: We can clean up the unmatched path a bit too
          var match = regex.matchAsPrefix(request.uri.path);
          if (match != null) {
            var pathParams = extract(params, match);
            var req = Request(request: request, pathParams: pathParams)
              ..setContainer(container.clone());

            var allMiddlewares = [...middleware, ...bindings[i].middleware];

            try {
              var handler = bindings[i].process;
              allMiddlewares.forEach((element) async {
                handler = element(handler);
              });

              var response = handler(req);
              await writeResponse(request, response);
            } catch (err, stacktrace) {
              await writeErrorResponse(request, err, stacktrace);
            }
            break;
          }
        }
      }

      if (!hasMatch) {
        // TODO: We can clean this up a bit
        var allMiddlewares = [...middleware];
        var handler = (Request req) => Future.value(Response.NotFound());
        allMiddlewares.forEach((element) {
          handler = element(handler);
        });

        var response = handler(Request(request: request));
        await writeResponse(request, response);
      }

      await request.response.close();
    }
  }

  Future<void> writeErrorResponse(request, err, stacktrace) async {
    if (container.make('@environment') == Environment.production) {
      // if things are production, we need to treat this all differently.
      return await writeResponse(request, Future.value(Response.Boom()));
    } else {
      return await writeResponse(request, Future.value(Response.Boom('''
Something went wrong.
${err.toString()}

${stacktrace.toString()}
''')));
    }
  }
}
