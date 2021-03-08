class Container {
  Map<String, dynamic> bindings;

  void bind(String key, dynamic Function(Container) fn) {
    this.bindings[key] = fn;
  }

  dynamic make(String key) {
    return this.bindings[key](this);
  }
}
