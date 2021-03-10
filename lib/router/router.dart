import 'package:drengr/container/container.dart';

enum HttpVerb {
  Connect,
  Delete,
  Get,
  Head,
  Options,
  Patch,
  Post,
  Put,
  Trace
}

class Binding {
  HttpVerb verb;
  String path;
  void Function() callback;

  Binding({this.verb, this.path, this.callback});
}



class Router {

  Container container;
  List<Binding> bindings = [];
  
  void setDIContainer(Container container) {
    this.container = container;
  }

  void connect(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Connect, path: path, callback: callback));
  }

  void delete(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Delete, path: path, callback: callback));
  }

  void get(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Get, path: path, callback: callback));
  }

  void options(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Options, path: path, callback: callback));
  }

  void patch(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Patch, path: path, callback: callback));
  }

  void post(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Post, path: path, callback: callback));
  }

  void put(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Put, path: path, callback: callback));
  }

  void trace(String path, void Function() callback) {
    bindings.add(Binding(verb: HttpVerb.Trace, path: path, callback: callback));
  }


}
