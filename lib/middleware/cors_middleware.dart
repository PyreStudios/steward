import 'package:steward/steward.dart';

const _originKey = 'Access-Control-Allow-Origin';
const _methodsKey = 'Access-Control-Allow-Methods';
const _headersKey = 'Access-Control-Allow-Headers';

MiddlewareFunc CorsMiddleware(
    {List<String>? allowOrigin,
    List<String>? allowMethods,
    List<String>? allowHeaders}) {
  return (Response Function(Request) next) {
    return (Request request) {
      var resp = next(request);

      if (allowOrigin != null) {
        resp.headers.add(_originKey, allowOrigin);
      }

      if (allowMethods != null) {
        resp.headers.add(_methodsKey, allowMethods);
      }

      if (allowHeaders != null) {
        resp.headers.add(_headersKey, allowHeaders);
      }

      return resp;
    };
  };
}
