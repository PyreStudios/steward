import 'dart:convert';
import 'dart:io';
import 'package:steward/container/container.dart';

/// Request models the request object that Steward processes.
/// It is a wrapper around the [HttpRequest] object but this may change in future iterations.
/// Generally, you will not need to new up a request object on your own, but may find that useful
/// when working with middleware and/or intercepting incoming requests.
class Request {
  HttpRequest request;
  Container container = CacheContainer();
  Map<String, dynamic> pathParams;

  Request({required this.request, this.pathParams = const {}});

  /// Sets the container for this request
  /// This is useful for passing data between middleware and the controller
  /// but is also necessary as Steward expects the container to be present.
  /// If you new up a request manually, you will almost certainly want to
  /// set the container yourself.
  void setContainer(Container? container) {
    if (container != null) {
      this.container = container;
    }
  }

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
}
