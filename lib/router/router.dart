import 'dart:io';

import 'package:drengr/container/container.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

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

  Future serveHTTP() async {
    var server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      4040,
    );

    await for (HttpRequest request in server) {
      for (var i = 0; i < bindings.length; i++) {
        var params = <String>[];
        var regex = pathToRegExp(bindings[i].path, parameters: params);
        var hasMatch = regex.hasMatch(request.uri.path);
        
        if (hasMatch) {
          var match = regex.matchAsPrefix(request.uri.path);
          var pathParams = extract(params, match);
          
        }
        
        
      }
      request.response.write('Hello World');
      await request.response.close();
    }
  }


}
