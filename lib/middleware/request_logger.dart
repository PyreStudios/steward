import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';

/// An extremely simple Middleware function that prints the incoming request URI
/// helpful for debugging and in understanding how middleware functions are structured
Future<Response> Function(Request) RequestLogger(
    Future<Response> Function(Request) next) {
  return (Request request) {
    print('Incoming Request: ${request.uri}');
    return next(request);
  };
}
