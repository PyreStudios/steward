import 'dart:mirrors';

import 'package:steward/steward.dart';

abstract class RouteBindingDecorator {
  final String path;
  final HttpVerb verb;

  final List<MiddlewareFunc> middleware;

  const RouteBindingDecorator(this.path, this.verb,
      [this.middleware = const []]);
}

class Get extends RouteBindingDecorator {
  const Get(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Get, middleware);
}

class Post extends RouteBindingDecorator {
  const Post(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Post, middleware);
}

class Put extends RouteBindingDecorator {
  const Put(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Put, middleware);
}

class Patch extends RouteBindingDecorator {
  const Patch(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Patch, middleware);
}

class Delete extends RouteBindingDecorator {
  const Delete(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Delete, middleware);
}

class Trace extends RouteBindingDecorator {
  const Trace(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Trace, middleware);
}

class Head extends RouteBindingDecorator {
  const Head(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Head, middleware);
}

class Connect extends RouteBindingDecorator {
  const Connect(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Connect, middleware);
}

class Options extends RouteBindingDecorator {
  const Options(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Options, middleware);
}

/// Path annotation to be used on top level controllers to set a root path before mounting methods
class Path {
  final path;
  const Path(String this.path);
}

final GetAnnotation = reflectClass(Get);
final PutAnnotation = reflectClass(Put);
final PostAnnotation = reflectClass(Post);
final PatchAnnotation = reflectClass(Patch);
final DeleteAnnotation = reflectClass(Delete);
final TraceAnnotation = reflectClass(Trace);
final HeadAnnotation = reflectClass(Head);
final OptionsAnnotation = reflectClass(Options);
final ConnectAnnotation = reflectClass(Connect);
final PathAnnotation = reflectClass(Path);

final allHttpVerbs = [
  GetAnnotation,
  PutAnnotation,
  PostAnnotation,
  PatchAnnotation,
  DeleteAnnotation,
  TraceAnnotation,
  HeadAnnotation,
  OptionsAnnotation,
  ConnectAnnotation
];

class PathControllerReflectiveBinding {
  final String path;
  final HttpVerb verb;
  final Symbol method;
  final List<MiddlewareFunc> middlewares;

  PathControllerReflectiveBinding(this.path, this.verb, this.method,
      [this.middlewares = const []]);
}

List<PathControllerReflectiveBinding> getPaths(ClassMirror mirror) {
  final paths = <PathControllerReflectiveBinding>[];
  var basePath = '';

  // If the class has a @Path specified, we'll set it as the base
  mirror.metadata.forEach((metadata) {
    if (metadata.type == PathAnnotation) {
      basePath = (metadata.reflectee as Path).path;
    }
  });

  mirror.declarations.forEach((key, value) {
    value.metadata.forEach((meta) {
      if (allHttpVerbs.contains(meta.type)) {
        // This is indeed a verb!
        final injectable = (meta.reflectee as RouteBindingDecorator);
        paths.add(PathControllerReflectiveBinding(basePath + injectable.path,
            injectable.verb, value.simpleName, injectable.middleware));
      }
    });
  });

  return paths;
}
