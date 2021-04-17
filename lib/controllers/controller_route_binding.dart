import 'dart:mirrors';
import 'package:drengr/router/router.dart';
import 'package:drengr/router/request.dart';
import 'package:drengr/router/response.dart';
import 'package:drengr/controllers/controller.dart';

class ControllerRouteBinding extends RouteBinding {
  Controller controller;
  String methodName;
  ControllerRouteBinding({required HttpVerb verb, required String path, required this.controller, required this.methodName, middleware = const []}): super(verb: verb, path: path, middleware: middleware);

  @override
  Response process(Request request) {
    controller.setContainer(request.container);
    return reflect(controller).invoke(Symbol(methodName), [request]).reflectee as Response;
  }
}
