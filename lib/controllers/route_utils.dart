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
  final List<MiddlewareFunc> middleware;
  const Path(this.path, [this.middleware = const []]);
}

/// Annotation for creating GET route bindings
final getAnnotation = reflectClass(Get);

/// Annotation for creating PUT route bindings
final putAnnotation = reflectClass(Put);

/// Annotation for creating POST route bindings
final postAnnotation = reflectClass(Post);

/// Annotation for creating PATCH route bindings
final patchAnnotation = reflectClass(Patch);

/// Annotation for creating DELETE route bindings
final deleteAnnotation = reflectClass(Delete);

/// Annotation for creating TRACE route bindings
final traceAnnotation = reflectClass(Trace);

/// Annotation for creating HEAD route bindings
final headAnnotation = reflectClass(Head);

/// Annotation for creating OPTIONS route bindings
final optionsAnnotation = reflectClass(Options);

/// Annotation for creating CONNECT route bindings
final connectAnnotation = reflectClass(Connect);

/// Annotation for creating a root path for a controller
final pathAnnotation = reflectClass(Path);

final _allHttpVerbs = [
  getAnnotation,
  putAnnotation,
  postAnnotation,
  patchAnnotation,
  deleteAnnotation,
  traceAnnotation,
  headAnnotation,
  optionsAnnotation,
  connectAnnotation
];

class PathControllerReflectiveBinding extends RouteBindingDecorator {
  final Symbol method;

  PathControllerReflectiveBinding(String path, HttpVerb verb, this.method,
      [List<MiddlewareFunc> middleware = const []])
      : super(path, verb, middleware);
}

List<PathControllerReflectiveBinding> getPaths(ClassMirror mirror) {
  final paths = <PathControllerReflectiveBinding>[];
  Path? basePath;

  // If the class has a @Path specified, we'll set it as the base
  mirror.metadata.forEach((metadata) {
    if (metadata.type == pathAnnotation) {
      basePath = metadata.reflectee as Path;
    }
  });

  mirror.declarations.forEach((key, value) {
    value.metadata.forEach((meta) {
      if (_allHttpVerbs.contains(meta.type)) {
        // This is indeed a verb!
        final injectable = (meta.reflectee as RouteBindingDecorator);
        paths.add(PathControllerReflectiveBinding(
            (basePath?.path ?? '') + injectable.path,
            injectable.verb,
            value.simpleName,
            [...?(basePath?.middleware), ...injectable.middleware]));
      }
    });
  });

  return paths;
}
