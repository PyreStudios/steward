import 'package:steward/app/app.dart';
import 'package:steward/router/router.dart';

Future main() async {
  var router = Router();
  router.get('/hello', (Context context) async {
    return Response.Ok('Hello World!');
  });

  router.get('/config', (Context context) async {
    print(context.request);
    print(context.read('@config'));
    return Response.Ok(context.read('@config'));
  });

  router.get('/:name', (Context context) async {
    return Response.Ok(context.request.pathParams['name']);
  });

  var app = App(router: router);

  return app.start();
}
