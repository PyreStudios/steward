abstract class Container {
  void bind<T>(String key, T Function(Container) fn);
  T? make<T>(String key);

  /// Clones a container so that a new container can have values bound to it
  /// without updating this current container.
  Container clone();
}

/// A rudimentary DI container implementation
/// container bindings are created as needed.
class CacheContainer implements Container {
  Map<String, dynamic> bindings = {};

  /// Binds a new DI item into the container
  /// The function bound to the provided key will only be called when the container
  /// receives a request for the item at that key.
  @override
  void bind<T>(String key, T Function(Container) fn) {
    bindings[key] = fn;
  }

  /// Generate an item for a given key
  @override
  T? make<T>(String key) {
    if (bindings.containsKey(key)) {
      return bindings[key](this);
    }
    return null;
  }

  @override
  Container clone() {
    return CacheContainer()..bindings.addAll(bindings);
  }
}

/// Annotation to mark a class as injectable for the DI container to auto-inject
/// injection is not automatic and must be done by the framework.
class Injectable {
  const Injectable(this.containerKey);
  final String containerKey;
}
