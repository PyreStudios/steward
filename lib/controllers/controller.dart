import 'dart:io';
import 'dart:mirrors';

import 'package:steward/controllers/view_not_found_error.dart';
import 'package:steward/container/container.dart';
import 'package:mustache_template/mustache.dart';
import 'package:steward/router/response.dart';

// Controller is an abstract class set up to model what a controller has access to.
abstract class Controller {
  // Container must be set by the framework.
  late Container container;

  /// view renders a view from the DI container and returns a response with that
  /// processed view as the body of that response.
  Response view(String filename, {Map<String, dynamic> varMap = const {}}) {
    var templateString = '';
    try {
      templateString = container.make('@views.$filename');
    } catch (e) {
      throw ViewNotFoundError(filename);
    }
    var template = Template(templateString);
    var output = template.renderString(varMap);
    return Response.Ok(output)..headers.contentType = ContentType.html;
  }

  /// setContainer sets the container for a controller.
  /// As a consumer of this lib, You _probably_ dont need to call this.
  void setContainer(Container container) {
    this.container = container;
  }
}

// Initializer initializes an instance of a class and fills it with dependencies from the container
InstanceMirror initializer(Type clazz, Container container) {
  final clazzDeclaration = reflectClass(clazz);
  final injectableMirror = reflectClass(Injectable);
  var instance = clazzDeclaration.newInstance(const Symbol(''), []);

  clazzDeclaration.declarations.forEach((key, value) {
    value.metadata.forEach((meta) {
      if (meta.type == injectableMirror) {
        final injectable = (meta.reflectee as Injectable);
        final key = injectable.containerKey;
        final containerValue = container.make(key);
        instance.setField(value.simpleName, containerValue);
      }
    });
  });

  return instance;
}
