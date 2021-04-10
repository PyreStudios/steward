/// A rudimentary DI container implementation
/// container bindings are created as needed.
class Container {
  Map<String, dynamic> bindings = {};

  /// Binds a new DI item into the container
  /// The function bound to the provided key will only be called when the container
  /// receives a request for the item at that key.
  void bind(String key, dynamic Function(Container) fn) {
    bindings[key] = fn;
  }

  /// Generate an item for a given key
  dynamic make(String key) {
    return bindings[key](this);
  }
}
