import 'dart:io';

import 'package:steward/controllers/view_not_found_error.dart';
import 'package:steward/container/container.dart';
import 'package:mustache_template/mustache.dart';
import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';

import 'controller_mirror_factory.dart';

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

Future<Response> Function(Request request) controllerItemRouteHandler(
    Type controllerType, Symbol methodName) {
  return (Request request) {
    final _controller =
        ControllerMirrorFactory.createMirror(controllerType, request.container);
    final result = _controller.invoke(methodName, [request]).reflectee;
    if (result is Response) {
      return Future.value(result);
    } else if (result is Future<Response>) {
      return result;
    } else if (result is Future) {
      return result.then((value) => Response(200, body: value));
    } else {
      return Future.value(Response(200, body: result));
    }
  };
}
