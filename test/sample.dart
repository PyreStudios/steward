import 'package:steward/router/router.dart';

Future main() async {
  var router = Router();
  router.get('/hello', (Request request) async {
    return Response.Ok('Hello World!');
  });

  router.get('/:name', (Request request) async {
    return Response.Ok(request.pathParams['name']);
  });

  return router.serveHTTP();
}
