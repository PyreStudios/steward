import 'dart:io';

import 'package:steward/steward.dart';
import 'package:test/test.dart';

var middlewareLogger = <int>[];

/// An extremely simple Middleware function that prints the incoming request URI
Future<Response> Function(Context) FirstMiddleware(
    Future<Response> Function(Context) next) {
  return (Context context) {
    middlewareLogger.add(1);
    return next(context);
  };
}

Future<Response> Function(Context) SecondMiddleware(
    Future<Response> Function(Context) next) {
  return (Context context) {
    middlewareLogger.add(2);
    return next(context);
  };
}

Future<Response> Function(Context) ThirdMiddleware(
    Future<Response> Function(Context) next) {
  return (Context context) {
    middlewareLogger.add(3);
    return next(context);
  };
}

void main() {
  late Router router;

  setUp(() {
    router = Router();
    router.setDIContainer(StewardContainer());
    router.serveHTTP();
    middlewareLogger.clear();
  });

  tearDown(() async {
    await router.terminate();
  });

  test('Route Specific Middlewares execute from left to right order', () async {
    router.get('/', (Context context) async {
      return Response.Ok();
    }, middleware: [FirstMiddleware, SecondMiddleware, ThirdMiddleware]);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    await request.close();
    expect(middlewareLogger[0], equals(1));
    expect(middlewareLogger[1], equals(2));
    expect(middlewareLogger[2], equals(3));
  });

  test('Router level Middlewares execute from left to right order', () async {
    router.get('/', (request) async {
      return Response.Ok();
    });

    router.middleware = [FirstMiddleware, SecondMiddleware, ThirdMiddleware];

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    await request.close();
    expect(middlewareLogger[0], equals(1));
    expect(middlewareLogger[1], equals(2));
    expect(middlewareLogger[2], equals(3));
  });
}
