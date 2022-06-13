import 'package:steward/app/app.dart';
import 'package:steward/controllers/controller.dart';
import 'package:steward/controllers/route_utils.dart';
import 'package:steward/router/router.dart';

class SimpleController extends Controller {
  @Get('/show')
  Response show(Request request) {
    return Response.Ok('Hello from SimpleController@show');
  }
}

Future main() async {
  var router = Router();
  router.get('/hello', (Request request) async {
    return Response.Ok('Hello World!');
  });

  router.get('/config', (Request request) async {
    print(request.container);
    print(request.container.make('@config'));
    return Response.Ok(request.container.make('@config'));
  });

  router.mount(SimpleController);

  router.get('/:name', (Request request) async {
    return Response.Ok(request.pathParams['name']);
  });

  var app = App(router: router);

  return app.start();
}
