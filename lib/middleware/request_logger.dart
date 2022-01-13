import 'package:steward/router/request.dart';

import 'middleware.dart';

/// An extremely simple Middleware function that prints the incoming request URI
Handler RequestLogger(Handler next) {
  return (Request request) {
    print('Incoming Request: ${request.request.uri}');
    return next(request);
  };
}
