import 'dart:io';

import 'package:drengr/container/container.dart';
import 'package:drengr/router/response.dart';
import 'package:drengr/router/request.dart';
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

typedef RequestCallback = Response Function(Request request);

class Binding {
  HttpVerb verb;
  String path;
  RequestCallback callback;

  Binding({this.verb, this.path, this.callback});
}



class Router {

  Container container;
  List<Binding> bindings = [];

  void setDIContainer(Container container) {
    this.container = container;
  }

  void connect(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Connect, path: path, callback: callback));
  }

  void delete(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Delete, path: path, callback: callback));
  }

  void get(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Get, path: path, callback: callback));
  }

  void options(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Options, path: path, callback: callback));
  }

  void patch(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Patch, path: path, callback: callback));
  }

  void post(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Post, path: path, callback: callback));
  }

  void put(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Put, path: path, callback: callback));
  }

  void trace(String path, RequestCallback callback) {
    bindings.add(Binding(verb: HttpVerb.Trace, path: path, callback: callback));
  }

  Future serveHTTP() async {
    var server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      4040,
    );

    await for (HttpRequest request in server) {
      var hasMatch = false;
      for (var i = 0; i < bindings.length; i++) {
        var params = <String>[];
        var regex = pathToRegExp(bindings[i].path, parameters: params);
        hasMatch = regex.hasMatch(request.uri.path);

        if (hasMatch) {
          var match = regex.matchAsPrefix(request.uri.path);
          var pathParams = extract(params, match);
          var response = bindings[i].callback(Request(request: request, pathParams: pathParams));
          _renderResponse(request, response);
          break;
        }
      }

      if (!hasMatch) {
        request.response.statusCode = 404;
      }

      await request.response.close();
    }
  }

  void _renderResponse(HttpRequest request, Response response) {
    request.response.write(response.body);
  }


}
