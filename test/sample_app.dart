import 'package:steward/app/app.dart';
import 'package:steward/container/container.dart';
import 'package:steward/controllers/controller.dart';
import 'package:steward/router/router.dart';
import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';

class SimpleController extends Controller {
  Response show(Request request) {
    return Response.Ok('Hello from SimpleController@show');
  }
}

Future main() async {
  var router = Router();
  router.get('/hello', handler: (Request request) {
    return Response.Ok('Hello World!');
  });

  router.get('/config', handler: (Request request) {
    print(request.container);
    print(request.container.make('@config'));
    return Response.Ok(request.container.make('@config'));
  });

  router.get('/show', controller: SimpleController(), method: 'show');

  router.get('/:name', handler: (Request request) {
    return Response.Ok(request.pathParams['name']);
  });


  var container = Container();
  var app = App(router: router, container: container);

  return app.start();

}
