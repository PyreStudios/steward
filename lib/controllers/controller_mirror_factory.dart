import 'dart:mirrors';

import 'package:steward/container/container.dart';

/// ControllerMirrorFactory is a factory for creating InstanceMirrors of
/// Controller types. This involves injecting injectables into the controller
/// when newing it up.
class ControllerMirrorFactory {
  // createMirror initializes an instance of a class and fills it with dependencies from the container, then retturns a mirror of that instance.
  static InstanceMirror createMirror(Type clazz, Container container) {
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
}
