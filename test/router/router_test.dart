import 'dart:convert';
import 'dart:io';

import 'package:steward/controllers/route_utils.dart';
import 'package:steward/steward.dart';
import 'package:test/test.dart';

class UserService {
  String gimme() => 'got it';
}

class ComplexResponseBody {
  String content = 'Hello';

  toJson() => {'content': content};
}

@Path('/cont')
class Cont extends Controller {
  @Get('/')
  String get(_) => userService?.gimme() ?? 'no user service in container';

  @Injectable('UserService')
  late UserService? userService;
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
    router.get('/', (_) async {
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
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/cont/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first,
        equals('no user service in container'));
  });

  test('Router injects container items into mounted Controller', () async {
    router.container.bind('UserService', (_) => UserService());
    router.mount(Cont);

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/cont/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('got it'));
  });

  test('Router responds appropriately to simple POST requests', () async {
    router.post('/', (_) async {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.post(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to get requests with object bodies',
      () async {
    router.post('/', (_) async {
      return Response.Ok(ComplexResponseBody());
    });

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first,
        equals('{"content":"Hello"}'));
  });

  test('Router responds appropriately to simple PUT requests', () async {
    router.put('/', (_) async {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.put(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple DELETE requests', () async {
    router.delete('/', (_) async {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.delete(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple PATCH requests', () async {
    router.patch('/', (_) async {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request =
        await client.patch(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple HEAD requests', () async {
    router.head('/', (_) async {
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
    router.get('/', (_) async {
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
    router.get('/', (_) async {
      return Response.Ok('Success');
    }, middleware: [
      (Future<Response> Function(Request) next) {
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
      (Future<Response> Function(Request) next) {
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

  test('Router still responds when an exception is raised', () async {
    router.post('/', (_) async {
      throw Exception('OH NO');
    });

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(response.statusCode, equals(500));
    expect(await response.transform(utf8.decoder).first,
        contains('Exception: OH NO'));
  });

  test('Router supports trailing slash as well as not trailing slash',
      () async {
    var counter = 0;
    router.post('/nice', (_) async {
      counter++;
      return Response.Ok();
    });

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/nice');
    final response = await request.close();
    expect(counter, equals(1));
    final request2 =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/nice/');
    final response2 = await request2.close();
    expect(counter, equals(2));
    final request3 =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/nice/hat');
    final response3 = await request3.close();
    expect(counter, equals(2));
  });

  test('Router supports case insensitive matching', () async {
    var counter = 0;
    router.post('/nice', (_) async {
      counter++;
      return Response.Ok();
    });

    final client = HttpClient();
    final request =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/nice');
    final response = await request.close();
    expect(counter, equals(1));
    final request2 =
        await client.get(InternetAddress.loopbackIPv4.host, 4040, '/NICE');
    final response2 = await request2.close();
    expect(counter, equals(2));
  });
}
