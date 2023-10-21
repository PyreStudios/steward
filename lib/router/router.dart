import 'dart:io';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:steward/router/static_binding.dart';
import 'package:steward/steward.dart';

export 'package:steward/router/response.dart';
export 'package:steward/router/request.dart';
export 'package:steward/router/context.dart';

enum HttpVerb { Connect, Delete, Get, Head, Options, Patch, Post, Put, Trace }

typedef RequestCallback = Future<Response> Function(Context context);

abstract class Processable {
  Future<Response> process(Context context);
}

abstract class RouteBinding implements Processable {
  late HttpVerb verb;
  late String path;
  List<MiddlewareFunc> middleware = [];

  bool get isPrefixBinding;

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
  Future<Response> process(Context context) {
    return callback(context);
  }

  @override
  bool get isPrefixBinding => false;
}

class Router {
  StewardContainer container = StewardContainer();
  List<RouteBinding> bindings = [];
  List<MiddlewareFunc> middleware = [];
  HttpServer? server;
  dynamic address = InternetAddress.anyIPv4;

  Router({this.address});

  void setDIContainer(StewardContainer container) {
    this.container = container;
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

  void staticFiles(String path, {List<MiddlewareFunc> middleware = const []}) =>
      bindings.add(StaticBinding(path: path, middleware: middleware));

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
    var port = container.read('@config.app.port') ?? 4040;
    server = await HttpServer.bind(
      InternetAddress.anyIPv6,
      port,
    );

    print('Bound server to port $port');

    await for (HttpRequest request in server!) {
      var hasMatch = false;
      for (var i = 0; i < bindings.length; i++) {
        var params = <String>[];

// Get the root pattern from the pathToRegex call
        var rootPattern = pathToRegExp(bindings[i].path,
                parameters: params, prefix: bindings[i].isPrefixBinding)
            .pattern;

        // TODO: Circumvent this for prefix bindings I guess?

        // Build a new regex by removing the $, adding in the optional trailing slash
        // and then adding the end terminator back on ($).
        var cleanedPattern =
            rootPattern.substring(0, rootPattern.lastIndexOf('\$'));
        // account for the path already ending in slash
        if (cleanedPattern.endsWith('/')) {
          cleanedPattern =
              cleanedPattern.substring(0, cleanedPattern.length - 1);
        }
        var regex = RegExp(
            '$cleanedPattern\\/?${bindings[i].isPrefixBinding ? '\$)' : '\$'}',
            caseSensitive: false);
        hasMatch = regex.hasMatch(request.uri.path);

        if (hasMatch) {
          var match = regex.matchAsPrefix(request.uri.path);
          if (match != null) {
            var pathParams = extract(params, match);

            final ctx = StewardContext(
                request: Request(request: request, pathParams: pathParams),
                container: container.clone());

            await processHandlersWithMiddleware(
                bindings[i].process,
                [
                  ...bindings[i].middleware.reversed,
                  ...middleware.reversed,
                ],
                ctx,
                request);
            break;
          }
        }
      }

      if (!hasMatch) {
        await processHandlersWithMiddleware(
            (Context context) => Future.value(Response.NotFound()),
            [...middleware.reversed],
            StewardContext(
                request: Request(request: request),
                container: container.clone()),
            request);
      }

      await request.response.close();
    }
  }

  Future<void> processHandlersWithMiddleware(
      Future<Response> Function(Context context) initialHandler,
      List<Function> allMiddlewares,
      Context context,
      HttpRequest request) async {
    try {
      var handler = initialHandler;
      allMiddlewares.forEach((element) async {
        handler = element(handler);
      });

      var response = handler(context);
      await writeResponse(request, response);
    } catch (err, stacktrace) {
      await writeErrorResponse(request, err, stacktrace);
    }
  }

  Future<void> writeErrorResponse(request, err, stacktrace) async {
    if (container.read('@environment') == Environment.production) {
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
