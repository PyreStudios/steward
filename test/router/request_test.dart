import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:steward/steward.dart';
import 'package:test/test.dart';

class FakeCert extends Fake implements X509Certificate {
  @override
  String get issuer => 'issuer';
}

class FakeHttpSession extends Fake implements HttpSession {
  @override
  String get id => 'id';
}

class FakedRequest extends Fake implements HttpRequest {
  @override
  List<Cookie> get cookies => [Cookie('cookiename', 'cookievalue')];

  @override
  X509Certificate get certificate => FakeCert();

  @override
  HttpSession get session => FakeHttpSession();
}

void main() {
  group('Request', () {
    test('Can furnish cookies from underlying request', () async {
      final mockRequest = FakedRequest();
      final request = Request(request: mockRequest);
      expect(request.cookies.first.name, equals('cookiename'));
      expect(request.cookies.first.value, equals('cookievalue'));
    });

    test('Can get the underlying certificate', () async {
      final mockRequest = FakedRequest();
      final request = Request(request: mockRequest);
      expect(request.certificate!.issuer, equals('issuer'));
    });

    test('Can get the underlying session', () async {
      final mockRequest = FakedRequest();
      final request = Request(request: mockRequest);
      expect(request.session.id, equals('id'));
    });
  });
}
