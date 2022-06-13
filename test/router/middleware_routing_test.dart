import 'dart:convert';
import 'dart:io';

import 'package:steward/controllers/route_utils.dart';
import 'package:steward/steward.dart';
import 'package:test/test.dart';

var middlewareLogger = <int>[];

/// An extremely simple Middleware function that prints the incoming request URI
Future<Response> Function(Request) FirstMiddleware(
    Future<Response> Function(Request) next) {
  return (Request request) {
    middlewareLogger.add(1);
    return next(request);
  };
}

Future<Response> Function(Request) SecondMiddleware(
    Future<Response> Function(Request) next) {
  return (Request request) {
    middlewareLogger.add(2);
    return next(request);
  };
}

Future<Response> Function(Request) ThirdMiddleware(
    Future<Response> Function(Request) next) {
  return (Request request) {
    middlewareLogger.add(3);
    return next(request);
  };
}

@Path('/cont')
class Cont extends Controller {
  static const body = 'test middleware should be called';

  @Get('/', [FirstMiddleware, SecondMiddleware, ThirdMiddleware])
  String get(_) => body;
}

void main() {
  late Router router;

  setUp(() {
    router = Router();
    router.setDIContainer(CacheContainer());
    router.serveHTTP();
    middlewareLogger.clear();
  });

  tearDown(() async {
    await router.terminate();
  });

  test('Route Specific Middlewares execute from left to right order', () async {
    router.mount(Cont);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/cont/');
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
