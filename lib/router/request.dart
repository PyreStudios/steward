import 'dart:convert';
import 'dart:io';

/// Request models the request object that Steward processes.
/// It is a wrapper around the [HttpRequest] object but this may change in future iterations.
/// Generally, you will not need to new up a request object on your own, but may find that useful
/// when working with middleware and/or intercepting incoming requests.
class Request {
  HttpRequest request;
  Map<String, dynamic> pathParams;

  Request({required this.request, this.pathParams = const {}});

  /// Returns the body of this request as a Future<String>.
  Future<String> getBody() {
    return utf8.decodeStream(request);
  }

  /// Gets cookies associated with this request
  List<Cookie> get cookies => request.cookies;

  /// Gets the x509 certificate associated with this request
  X509Certificate? get certificate => request.certificate;

  /// Gets the HTTPSession associated with this request
  HttpSession get session => request.session;

  /// Gets the URI of the request
  Uri get uri => request.uri;
}
