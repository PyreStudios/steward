import 'dart:mirrors';
import 'package:drengr/router/router.dart';
import 'package:drengr/controller/controller.dart';

class ControllerRouteBinding extends Binding {
  ControllerRouteBinding({required HttpVerb verb, required String path, required Controller controller, required String methodName}) {
    
    super(verb: verb, path: path, callback: callback);
  }
}
