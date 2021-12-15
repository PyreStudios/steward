import 'dart:convert';
import 'dart:io';

import 'package:steward/controllers/verbs.dart';
import 'package:steward/middleware/middleware.dart';
import 'package:steward/steward.dart';
import 'package:test/test.dart';

class UserService {
  String gimme() => 'got it';
}

class Cont extends Controller {
  @Get('/')
  String get(_) => userService.gimme();

  @Injectable('UserService')
  late UserService userService;
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

  test('Router responds appropriately to simple GET requests', () async {
    router.get('/', (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple GET requests w/ Controller',
      () async {
    router.mount(Cont);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first,
        equals('controller get response'));
  });

  test('Router injects container items into mounted Controller', () async {
    router.container.bind('UserService', (_) => UserService());
    router.mount(Cont);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('got it'));
  });

  test('Router responds appropriately to simple POST requests', () async {
    router.post('/', (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.post(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple PUT requests', () async {
    router.put('/', (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.put(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple DELETE requests', () async {
    router.delete('/', (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.delete(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple PATCH requests', () async {
    router.patch('/', (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.patch(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple HEAD requests', () async {
    router.head('/', (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.head(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(response.statusCode, equals(HttpStatus.ok));
  });

  test('Router returns a response with a 404 error code when no match is found',
      () async {
    router.get('/', (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.get(
        InternetAddress.loopbackIPv4.host, 4040, '/does-not-exist');
    final response = await request.close();
    expect(response.statusCode, HttpStatus.notFound);
  });

  test(
      'Router should trigger binding-specific middleware on all matched requests',
      () async {
    var called = false;
    router.get('/', (_) {
      return Response.Ok('Success');
    }, middleware: [
      (Handler next) {
        called = true;
        return (Request request) {
          return next(request);
        };
      }
    ]);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    await request.close();
    expect(called, true);
  });

  test(
      'Router should trigger router-specific middleware on all incoming requests',
      () async {
    var called = false;
    router.middleware = [
      (Handler next) {
        called = true;
        return (Request request) {
          return next(request);
        };
      }
    ];

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    await request.close();
    expect(called, true);
  });
}
