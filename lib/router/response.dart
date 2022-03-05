import 'dart:io';
import 'dart:convert';

const _originKey = 'Access-Control-Allow-Origin';
const _methodsKey = 'Access-Control-Allow-Methods';
const _headersKey = 'Access-Control-Allow-Headers';

class Headers {
  ContentType? contentType;
  DateTime? date = DateTime.now();
  final Map<String, List<String>> _headers = {};

  Headers();

  void set(String key, List<String> value) {
    _headers[key] = value;
  }

  void add(String key, List<String> value) {
    if (_headers[key] == null) {
      _headers[key] = value;
    } else {
      _headers[key]?.addAll(value);
    }
  }

  List<String>? operator [](String key) {
    return _headers[key];
  }
}

class Response {
  int statusCode;
  Headers headers = Headers();
  // this could be anything!
  dynamic body;

  Response(this.statusCode, {this.body});

  Response.Ok([dynamic body]) : this(HttpStatus.ok, body: body);

  Response.Created([dynamic body]) : this(HttpStatus.created, body: body);

  Response.BadRequest([dynamic body]) : this(HttpStatus.badRequest, body: body);

  Response.Unauthorized([dynamic body])
      : this(HttpStatus.unauthorized, body: body);

  Response.Forbidden([dynamic body]) : this(HttpStatus.forbidden, body: body);

  Response.NotFound([dynamic body]) : this(HttpStatus.notFound, body: body);

  Response.InternalServerError([dynamic body])
      : this(HttpStatus.internalServerError, body: body);

  Response.Boom([dynamic body])
      : this(HttpStatus.internalServerError, body: body);
}

/// writeResponse takes in an HTTP request and a steward response, and writes the
/// contents of the steward response to the HTTP response.
Future<void> writeResponse(HttpRequest request, Future<Response> resp) async {
  // if we dont know what the content type is at this point, we infer it.
  var response = await resp;
  var body = await response.body;
  var jsonBody = jsonEncode(body);
  if (response.headers.contentType == null) {
    var jsonRegex = RegExp('/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/');
    if (jsonRegex.hasMatch(jsonBody)) {
      response.headers.contentType = ContentType.json;
      body = jsonBody;
    } else {
      response.headers.contentType = ContentType.text;
    }
  }
  request.response.headers.contentType = response.headers.contentType;
  request.response.headers.date = response.headers.date;

  if (response.headers[_headersKey] != null) {
    request.response.headers.set(_headersKey, response.headers[_headersKey]!);
  }

  if (response.headers[_originKey] != null) {
    request.response.headers.set(_originKey, response.headers[_originKey]!);
  }

  if (response.headers[_methodsKey] != null) {
    request.response.headers.set(_methodsKey, response.headers[_methodsKey]!);
  }

  request.response.statusCode = response.statusCode;
  request.response.write(body);

  return;
}
