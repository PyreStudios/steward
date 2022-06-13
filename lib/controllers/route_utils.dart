import 'dart:mirrors';

import 'package:steward/steward.dart';

/// RouteBindingDecorators are used to illustrated a verb/path binding and
/// the middleware associated with it.
abstract class RouteBindingDecorator {
  final String path;
  final HttpVerb verb;

  final List<MiddlewareFunc> middleware;

  const RouteBindingDecorator(this.path, this.verb,
      [this.middleware = const []]);
}

/// Helper for creating RouteBindingDecorators with a GET verb.
class Get extends RouteBindingDecorator {
  const Get(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Get, middleware);
}

/// Helper for creating RouteBindingDecorators with a POST verb.
class Post extends RouteBindingDecorator {
  const Post(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Post, middleware);
}

/// Helper for creating RouteBindingDecorators with a PUT verb.
class Put extends RouteBindingDecorator {
  const Put(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Put, middleware);
}

/// Helper for creating RouteBindingDecorators with a PATCH verb.
class Patch extends RouteBindingDecorator {
  const Patch(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Patch, middleware);
}

/// Helper for creating RouteBindingDecorators with a DELETE verb.
class Delete extends RouteBindingDecorator {
  const Delete(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Delete, middleware);
}

/// Helper for creating RouteBindingDecorators with a TRACE verb.
class Trace extends RouteBindingDecorator {
  const Trace(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Trace, middleware);
}

/// Helper for creating RouteBindingDecorators with a HEAD verb.
class Head extends RouteBindingDecorator {
  const Head(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Head, middleware);
}

/// Helper for creating RouteBindingDecorators with a CONNECT verb.
class Connect extends RouteBindingDecorator {
  const Connect(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Connect, middleware);
}

/// Helper for creating RouteBindingDecorators with a OPTIONS verb.
class Options extends RouteBindingDecorator {
  const Options(String path, [List<MiddlewareFunc> middleware = const []])
      : super(path, HttpVerb.Options, middleware);
}

/// Path annotation to be used on top level controllers to set a root path before mounting methods
class Path {
  final String path;
  const Path(this.path);
}

/// Annotation for creating GET route bindings
final GetAnnotation = reflectClass(Get);

/// Annotation for creating PUT route bindings
final PutAnnotation = reflectClass(Put);

/// Annotation for creating POST route bindings
final PostAnnotation = reflectClass(Post);

/// Annotation for creating PATCH route bindings
final PatchAnnotation = reflectClass(Patch);

/// Annotation for creating DELETE route bindings
final DeleteAnnotation = reflectClass(Delete);

/// Annotation for creating TRACE route bindings
final TraceAnnotation = reflectClass(Trace);

/// Annotation for creating HEAD route bindings
final HeadAnnotation = reflectClass(Head);

/// Annotation for creating OPTIONS route bindings
final OptionsAnnotation = reflectClass(Options);

/// Annotation for creating CONNECT route bindings
final ConnectAnnotation = reflectClass(Connect);

/// Annotation for creating a root path for a controller
final PathAnnotation = reflectClass(Path);

final _allHttpVerbs = [
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

class PathControllerReflectiveBinding extends RouteBindingDecorator {
  final Symbol method;

  PathControllerReflectiveBinding(String path, HttpVerb verb, this.method,
      [List<MiddlewareFunc> middleware = const []])
      : super(path, verb, middleware);
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
      if (_allHttpVerbs.contains(meta.type)) {
        // This is indeed a verb!
        final injectable = (meta.reflectee as RouteBindingDecorator);
        paths.add(PathControllerReflectiveBinding(basePath + injectable.path,
            injectable.verb, value.simpleName, injectable.middleware));
      }
    });
  });

  return paths;
}
