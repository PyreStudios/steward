import 'dart:mirrors';

import 'package:steward/steward.dart';

abstract class RouteBindingDecorator {
  final String path;
  final HttpVerb verb;

  const RouteBindingDecorator(this.path, this.verb);
}

class Get extends RouteBindingDecorator {
  const Get(String path) : super(path, HttpVerb.Get);
}

class Post extends RouteBindingDecorator {
  const Post(String path) : super(path, HttpVerb.Post);
}

class Put extends RouteBindingDecorator {
  const Put(String path) : super(path, HttpVerb.Put);
}

class Patch extends RouteBindingDecorator {
  const Patch(String path) : super(path, HttpVerb.Patch);
}

class Delete extends RouteBindingDecorator {
  const Delete(String path) : super(path, HttpVerb.Delete);
}

class Trace extends RouteBindingDecorator {
  const Trace(String path) : super(path, HttpVerb.Trace);
}

class Head extends RouteBindingDecorator {
  const Head(String path) : super(path, HttpVerb.Head);
}

class Connect extends RouteBindingDecorator {
  const Connect(String path) : super(path, HttpVerb.Connect);
}

class Options extends RouteBindingDecorator {
  const Options(String path) : super(path, HttpVerb.Options);
}

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

  PathControllerReflectiveBinding(this.path, this.verb, this.method);
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
        paths.add(PathControllerReflectiveBinding(
            basePath + injectable.path, injectable.verb, value.simpleName));
      }
    });
  });

  return paths;
}
