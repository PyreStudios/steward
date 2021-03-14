import 'package:drengr/app/app.dart';
import 'package:drengr/container/container.dart';
import 'package:drengr/router/router.dart';
import 'package:drengr/router/request.dart';
import 'package:drengr/router/response.dart';

Future main() async {
  var router = Router();
  router.get('/hello', (Request request) {
    return Response.Ok('Hello World!');
  });

  router.get('/config', (Request request) {
    print(request.container);
    print(request.container.make('@config'));
    return Response.Ok(request.container.make('@config'));
  });

  router.get('/:name', (Request request) {
    return Response.Ok(request.pathParams['name']);
  });


  var container = Container();
  var app = App(router: router, container: container);

  return app.start();

}
