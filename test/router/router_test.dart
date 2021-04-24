import 'dart:convert';
import 'dart:io';

import 'package:drengr/router/response.dart';
import 'package:drengr/router/router.dart';
import 'package:test/test.dart';

void main() {

  Router? router;

  setUp(() async {
    router = Router();
    router?.serveHTTP();
  });

  tearDown(() async {
    await router?.terminate();
    router = null;
  });

  test('Router responds appropriately to simple GET requests', () async {
    router?.get('/', handler: (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple POST requests', () async {
    router?.post('/', handler: (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.post(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple PUT requests', () async {
    router?.put('/', handler: (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.put(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple DELETE requests', () async {
    router?.delete('/', handler: (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.delete(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple PATCH requests', () async {
    router?.patch('/', handler: (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.patch(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(await response.transform(utf8.decoder).first, equals('Success'));
  });

  test('Router responds appropriately to simple HEAD requests', () async {
    router?.head('/', handler: (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.head(InternetAddress.loopbackIPv4.host, 4040, '/');
    final response = await request.close();
    expect(response.statusCode, equals(HttpStatus.ok));
  });


  test('Router returns a response with a 404 error code when no match is found', () async {
    router?.get('/', handler: (_) {
      return Response.Ok('Success');
    });

    final client = HttpClient();
    final request = await client.get(InternetAddress.loopbackIPv4.host, 4040, '/does-not-exist');
    final response = await request.close();
    expect(response.statusCode, HttpStatus.notFound);
  });

  test('Router should trigger binding-specific middleware on all matched requests', () async {
    var called = false;
    router?.get('/', handler: (_) {
      return Response.Ok('Success');
    }, middleware: [(Request) {
      called = true;
    }]);

    final client = HttpClient();
    final request = await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    await request.close();
    expect(called, true); 
  });

  test('Router should trigger router-specific middleware on all incoming requests', () async {
    var called = false;
    router?.middleware = [(Request) {
      called = true;
    }];

    final client = HttpClient();
    final request = await client.get(InternetAddress.loopbackIPv4.host, 4040, '/');
    await request.close();
    expect(called, true); 
  });

}
