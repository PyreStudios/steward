import 'dart:io';
import 'dart:convert';
import 'package:xml/xml.dart';

const _originKey = 'Access-Control-Allow-Origin';
const _methodsKey = 'Access-Control-Allow-Methods';
const _headersKey = 'Access-Control-Allow-Headers';
const _cookieKey = 'Set-Cookie';

/// Models HTTP Headers that can be managed by the framework.
class Headers {
  ContentType? contentType;
  DateTime? date = DateTime.now();
  final Map<String, List<String>> _headers = {};

  Headers();

  /// Sets the values of the header with the given name.
  /// Overrides existing values if the header already exists.
  void set(String key, List<String> value) {
    _headers[key] = value;
  }

  /// Adds a header with the given name and values.
  /// Appends to the existing values if the header already exists.
  void add(String key, List<String> value) {
    if (_headers[key] == null) {
      _headers[key] = value;
    } else {
      _headers[key]?.addAll(value);
    }
  }

  /// Easily index into the headers map.
  List<String>? operator [](String key) {
    return _headers[key];
  }
}

/// Models an HTTP Response
/// Steward processes this response and writes out the necessary data to the
/// live HTTP response.
class Response {
  int statusCode;
  Headers headers = Headers();
  // this could be anything!
  dynamic body;

  /// Whether the connection should be persistent or not
  bool persistent = false;

  /// General constructor, sets the status code and body.
  Response(this.statusCode, {this.body, this.persistent = false});

  /// Constructor for 200 OK responses.
  Response.Ok([dynamic body]) : this(HttpStatus.ok, body: body);

  /// Constructor for 201 Created responses.
  Response.Created([dynamic body]) : this(HttpStatus.created, body: body);

  /// Constructor for 400 bad request responses.
  Response.BadRequest([dynamic body]) : this(HttpStatus.badRequest, body: body);

  /// Constructor for 401 unauthorized responses.
  Response.Unauthorized([dynamic body])
      : this(HttpStatus.unauthorized, body: body);

  /// Constructor for 403 forbidden responses.
  Response.Forbidden([dynamic body]) : this(HttpStatus.forbidden, body: body);

  /// Constructor for 404 not found responses.
  Response.NotFound([dynamic body]) : this(HttpStatus.notFound, body: body);

  /// Constructor for 500 internal server error responses.
  Response.InternalServerError([dynamic body])
      : this(HttpStatus.internalServerError, body: body);

  /// Alternative Constructor for 500 internal server error responses.
  Response.Boom([dynamic body])
      : this(HttpStatus.internalServerError, body: body);

  /// Constructor for 302 redirect responses.
  Response.Redirect(String location)
      : this(HttpStatus.temporaryRedirect, body: location);

  /// Constructor for 303 redirect responses.
  Response.RedirectForever(String location)
      : this(HttpStatus.permanentRedirect, body: location);

  /// Sets the cookies on the response as headers
  void setCookies(List<Cookie> cookies) {
    cookies.forEach((cookie) {
      headers.add(_cookieKey, [cookie.toString()]);
    });
  }
}

/// writeResponse takes in an HTTP request and a steward response, and writes the
/// contents of the steward response to the HTTP response.
/// TODO: this should only be called by Steward
Future<void> writeResponse(HttpRequest request, Future<Response> resp) async {
  // if we dont know what the content type is at this point, we infer it.
  var response = await resp;
  var body = await response.body;
  var jsonBody = body;
  try {
    jsonBody = jsonEncode(body);
  } catch (_) {
    // TODO: should we warn the user that this failed?
  }
  var bodyIsJsonable = jsonBody != body;

  if (response.headers.contentType == null) {
    if (bodyIsJsonable && body is! String) {
      response.headers.contentType = ContentType.json;
    } else {
      try {
        XmlDocument.parse(body);
        response.headers.contentType = ContentType.parse('application/xml');
      } catch (e) {
        response.headers.contentType = ContentType.text;
      }
    }
  }

  // If this _SHOULD_ be JSON and the body can be converted to JSON, do it!
  if (response.headers.contentType == ContentType.json &&
      bodyIsJsonable &&
      !(body is int || body is double || body is String || body == null)) {
    body = jsonBody;
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
