/// ViewNotFoundError is thrown when we try to load a view that doesn't exist.
class ViewNotFoundError extends Error {
  String fileName;

  ViewNotFoundError(this.fileName);
}

abstract interface class Cloneable<T> {
  T clone();
}

abstract interface class ContainerReable {
  T? read<T>(String key);
}

abstract interface class ContainerWriteable {
  void bind<T>(String key, T Function(Container) fn);
}

abstract interface class Container
    implements ContainerReable, ContainerWriteable {}

/// A rudimentary DI container implementation
/// container bindings are created as needed.
class StewardContainer implements Container, Cloneable<StewardContainer> {
  Map<String, dynamic> bindings = {};

  /// Binds a new DI item into the container
  /// The function bound to the provided key will only be called when the container
  /// receives a request for the item at that key.
  @override
  void bind<T>(String key, T Function(Container container) fn) {
    bindings[key] = fn;
  }

  /// Generate an item for a given key
  @override
  T? read<T>(String key) {
    if (bindings.containsKey(key)) {
      return bindings[key](this);
    }
    return null;
  }

  /// Load a file from the container
  /// TODO: This doesnt feel like the right path forward for this.
  String? view(String filename) {
    String templateString;
    try {
      templateString = read('@views.$filename');
    } catch (e) {
      throw ViewNotFoundError(filename);
    }

    return templateString;
  }

  @override
  StewardContainer clone() {
    return StewardContainer()..bindings.addAll(bindings);
  }
}

/// Annotation to mark a class as injectable for the DI container to auto-inject
/// injection is not automatic and must be done by the framework.
class Injectable {
  const Injectable(this.containerKey);
  final String containerKey;
}
