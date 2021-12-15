import 'package:steward/app/app.dart';
import 'package:steward/container/container.dart';
import 'package:steward/controllers/controller.dart';
import 'package:steward/controllers/verbs.dart';
import 'package:steward/router/router.dart';

class SimpleController extends Controller {
  @Get('/show')
  Response show(Request request) {
    return Response.Ok('Hello from SimpleController@show');
  }
}

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

  router.mount(SimpleController);

  router.get('/:name', (Request request) {
    return Response.Ok(request.pathParams['name']);
  });

  var container = Container();
  var app = App(router: router, container: container);

  return app.start();
}
