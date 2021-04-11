import 'dart:mirrors';
import 'package:drengr/router/router.dart';
import 'package:drengr/router/request.dart';
import 'package:drengr/router/response.dart';
import 'package:drengr/controllers/controller.dart';

class ControllerRouteBinding extends Binding {
  ControllerRouteBinding({required HttpVerb verb, required String path, required Controller controller, required String methodName}): super(verb: verb, path: path, callback: (Request request) {
    return reflect(controller).invoke(Symbol(methodName), [request]) as Response;
  });
}
