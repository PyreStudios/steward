import 'package:steward/steward.dart';

const _originKey = 'Access-Control-Allow-Origin';
const _methodsKey = 'Access-Control-Allow-Methods';
const _headersKey = 'Access-Control-Allow-Headers';

/// The CORS middleware is a simple middleware that sets CORS headers for your requests
MiddlewareFunc CorsMiddleware(
    {List<String>? allowOrigin,
    List<String>? allowMethods,
    List<String>? allowHeaders}) {
  return (Future<Response> Function(Context) next) {
    return (Context context) async {
      var resp = await next(context);

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
