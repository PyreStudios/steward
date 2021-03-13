import 'dart:io';

class Request {
  HttpRequest request;
  Map<String, dynamic> pathParams;

  Request({this.request, this.pathParams});
}
