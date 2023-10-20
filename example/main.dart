import 'package:steward/app/app.dart';
import 'package:steward/router/router.dart';

Future main() async {
  var router = Router();

  router.staticFiles('/assets');
  router.get('/hello', (Request request) async {
    return Response.Ok('Hello World!');
  });

  router.get('/config', (Request request) async {
    print(request.container);
    print(request.container.make('@config'));
    return Response.Ok(request.container.make('@config'));
  });

  router.get('/:name', (Request request) async {
    return Response.Ok(request.pathParams['name']);
  });

  var app = App(router: router);

  return app.start();
}
