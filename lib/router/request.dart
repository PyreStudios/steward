import 'dart:convert';
import 'dart:io';
import 'package:steward/container/container.dart';

class Request {
  HttpRequest request;
  Container container = CacheContainer();
  Map<String, dynamic> pathParams;

  Request({required this.request, this.pathParams = const {}});

  void setContainer(Container? container) {
    if (container != null) {
      this.container = container;
    }
  }

  Future<String> getBody() {
    return utf8.decodeStream(request);
  }
}
