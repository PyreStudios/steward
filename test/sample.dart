import 'package:steward/router/router.dart';
import 'package:steward/router/response.dart';
import 'package:steward/router/request.dart';

Future main() async {
  var router = Router();
  router.get('/hello', (Request request) {
    return Response.Ok('Hello World!');
  });

  router.get('/:name', (Request request) {
    return Response.Ok(request.pathParams['name']);
  });

  return router.serveHTTP();
}
