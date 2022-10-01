---
sidebar_position: 4
---

# Middleware

Steward's router has support for Middleware functions that are executed before the route handler that they are attached to. The middleware function typedef is like so:

```dart
typedef MiddlewareFunc = Future<Response> Function(Request) Function(
    Future<Response> Function(Request) nextHandler);
```

While this may look complex, the actual implementation of a custom middleware is fairly straightforward. We can look to the middlewares that Steward ships for an example of how we can structure our own middleware. Let's take a look at the `RequestLogger` middleware:

```dart
/// An extremely simple Middleware function that prints the incoming request URI
/// helpful for debugging and in understanding how middleware functions are structured
Future<Response> Function(Request) RequestLogger(
    Future<Response> Function(Request) next) {
  return (Request request) {
    print('Incoming Request: ${request.request.uri}');
    return next(request);
  };
}
```

This `RequestLogger` returns a function that takes in a request and then returns the result of calling `next` with that `request`. Generally, your middleware will always return a function and that function with return `next(request)`. This keeps the middleware chain going, but should you want to terminate it early (for example, if a user is unauthorized), you can always return a Response instead of returning `next(request)`.

## Out of the Box Middleware

Steward ships with some middleware out of the box. Namely, you have:
- RequestLogger - used for logging incoming requests to STDOUT
- CORSMiddleware - used for configuring CORS headers

Middleware ships under a different module and should be imported like so: `import 'package:steward/middleware/cors_middleware.dart';`