import 'dart:io';

import 'package:mockito/mockito.dart';
import 'package:steward/router/response.dart';
import 'package:test/test.dart';

class FakeHttpHeaders extends Fake implements HttpHeaders {
  ContentType? _contentType;
  DateTime? _date;
  final Map<String, dynamic> _headers = {};

  @override
  DateTime? get date => _date;

  @override
  set date(DateTime? _date) {
    this._date = _date;
  }

  @override
  ContentType? get contentType => _contentType;

  @override
  set contentType(ContentType? _contentType) {
    this._contentType = _contentType;
  }

  @override
  void set(String name, Object value, {bool preserveHeaderCase = false}) {
    _headers['name'] = value;
  }

  @override
  List<String> operator [](String name) {
    return _headers[name];
  }
}

class FakeHttpResponse extends Fake implements HttpResponse {
  int _statusCode = 200;
  final FakeHttpHeaders _headers = FakeHttpHeaders();
  dynamic body;

  @override
  HttpHeaders get headers => _headers;

  @override
  int get statusCode => _statusCode;

  @override
  set statusCode(int _statusCode) {
    this._statusCode = statusCode;
  }

  @override
  void write(Object? object) {
    body = object;
  }
}

class FakeHttpRequest extends Fake implements HttpRequest {
  final FakeHttpResponse _response = FakeHttpResponse();
  @override
  HttpResponse get response => _response;
}

void main() {
  group('Response', () {
    group('Named constructors', () {
      test('Ok', () {
        final response = Response.Ok('Hello world!');
        expect(response.statusCode, HttpStatus.ok);
        expect(response.body, equals('Hello world!'));
      });

      test('Created', () {
        final response = Response.Created('Hello world!');
        expect(response.statusCode, HttpStatus.created);
        expect(response.body, equals('Hello world!'));
      });

      test('BadRequest', () {
        final response = Response.BadRequest('Hello world!');
        expect(response.statusCode, HttpStatus.badRequest);
        expect(response.body, equals('Hello world!'));
      });

      test('Unauthorized', () {
        final response = Response.Unauthorized('Hello world!');
        expect(response.statusCode, HttpStatus.unauthorized);
        expect(response.body, equals('Hello world!'));
      });

      test('Forbidden', () {
        final response = Response.Forbidden('Hello world!');
        expect(response.statusCode, HttpStatus.forbidden);
        expect(response.body, equals('Hello world!'));
      });

      test('NotFound', () {
        final response = Response.NotFound('Hello world!');
        expect(response.statusCode, HttpStatus.notFound);
        expect(response.body, equals('Hello world!'));
      });

      test('InternalServerError', () {
        final response = Response.InternalServerError('Hello world!');
        expect(response.statusCode, HttpStatus.internalServerError);
        expect(response.body, equals('Hello world!'));
      });

      test('Boom', () {
        final response = Response.Boom('Hello world!');
        expect(response.statusCode, HttpStatus.internalServerError);
        expect(response.body, equals('Hello world!'));
      });
    });
    group('Write response', () {
      test('handles basic strings', () async {
        final response = Response.Ok('version 1.0');
        final httpReq = FakeHttpRequest();
        await writeResponse(httpReq, Future.value(response));
        expect(httpReq.response.headers.contentType, equals(ContentType.text));
        expect(
            (httpReq.response as FakeHttpResponse).body, equals('version 1.0'));
      });
      group('sets content type', () {
        test('when body is json-able', () async {
          final response = Response.Ok([]);
          final httpReq = FakeHttpRequest();
          await writeResponse(httpReq, Future.value(response));
          expect(
              httpReq.response.headers.contentType, equals(ContentType.json));
          expect((httpReq.response as FakeHttpResponse).body, equals('[]'));
        });

        test('when body is valid xml', () async {
          final body = """
<note>
<to>Tove</to>
<from>Jani</from>
<heading>Reminder</heading>
<body>Don't forget me this weekend!</body>
</note>
""";
          final response = Response.Ok(body);
          final httpReq = FakeHttpRequest();
          await writeResponse(httpReq, Future.value(response));
          expect(httpReq.response.headers.contentType!.mimeType,
              equals('application/xml'));
          expect((httpReq.response as FakeHttpResponse).body, equals(body));
        });

        test('when body is not json-able', () async {
          final response = Response.Forbidden(Exception('No access'));
          final httpReq = FakeHttpRequest();
          await writeResponse(httpReq, Future.value(response));
          expect(
              httpReq.response.headers.contentType, equals(ContentType.text));
          expect((httpReq.response as FakeHttpResponse).body, isA<Exception>());
        });
      });
    });
  });

  group('Headers', () {
    group('set', () {
      final headers = Headers();
      test('sets values as expected', () async {
        headers.set('key', ['value']);
        expect(headers['key'], equals(['value']));
      });
    });

    group('add', () {
      final headers = Headers();

      test('adds values as expected to existing keys', () async {
        headers.add('new_key', ['value1']);
        expect(headers['new_key'], equals(['value1']));
      });

      test('adds values as expected to existing keys', () async {
        headers.set('key', ['value']);
        expect(headers['key'], equals(['value']));
        headers.add('key', ['value2']);
        expect(headers['key'], equals(['value', 'value2']));
      });
    });
  });
}
