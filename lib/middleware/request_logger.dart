import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';

/// An extremely simple Middleware function that prints the incoming request URI
Future<Response> Function(Request) RequestLogger(
    Future<Response> Function(Request) next) {
  return (Request request) {
    print('Incoming Request: ${request.request.uri}');
    return next(request);
  };
}
