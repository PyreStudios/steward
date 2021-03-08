class Container {
  Map<String, dynamic> bindings = {};

  void bind(String key, dynamic Function(Container) fn) {
    bindings[key] = fn;
  }

  dynamic make(String key) {
    return bindings[key](this);
  }
}
