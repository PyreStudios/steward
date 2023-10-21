import 'package:steward/router/router.dart';

Future main() async {
  var router = Router();
  router.get('/hello', (Context context) async {
    return Response.Ok('Hello World!');
  });

  router.get('/:name', (Context context) async {
    return Response.Ok(context.request.pathParams['name']);
  });

  return router.serveHTTP();
}
