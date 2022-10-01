import 'dart:convert';
import 'dart:io';

import 'package:steward/controllers/route_utils.dart';
import 'package:steward/steward.dart';
import 'package:test/test.dart';

var handlerMiddlewareCalled = false;
var controllerMiddlewareCalled = false;

/// An extremely simple Middleware function that prints the incoming request URI
Future<Response> Function(Request) TestMiddleware(
    Future<Response> Function(Request) next) {
  return (Request request) {
    handlerMiddlewareCalled = true;
    return next(request);
  };
}

Future<Response> Function(Request) ControllerMiddleware(
    Future<Response> Function(Request) next) {
  return (Request request) {
    controllerMiddlewareCalled = true;
    return next(request);
  };
}

@Path('/cont', [ControllerMiddleware])
class Cont extends Controller {
  static const body = 'test middleware should be called';

  @Get('/', [TestMiddleware])
  String get(_) => body;
}

void main() {
  late Router router;

  setUp(() {
    router = Router();
    router.setDIContainer(CacheContainer());
    router.serveHTTP();
  });

  tearDown(() async {
    await router.terminate();
  });

  test('Complex Controller Routing', () async {
    router.mount(Cont);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/cont/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals(Cont.body));
    expect(handlerMiddlewareCalled, isTrue,
        reason: 'Handler Middleware did not trigger properly');
    expect(controllerMiddlewareCalled, isTrue,
        reason: 'Controller middleware did not trigger properly');
  });

  test('Trailing slash should not be required on a / path', () async {
    router.mount(Cont);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/cont');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals(Cont.body));
  });
}
