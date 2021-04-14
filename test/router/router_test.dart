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
}
