import 'package:steward/controllers/controller_mirror_factory.dart';
import 'package:steward/steward.dart';
import 'package:test/test.dart';

class TestController extends Controller {
  @Injectable('@SecretKey')
  late String secretKey;
}

void main() {
  late TestController controller;
  late Container container;
  setUp(() {
    controller = TestController();
    container = CacheContainer();
    container.bind<String>('@SecretKey', (_) => 'secret');
    controller.setContainer(container);
  });

  group('Injectables', () {
    test('should inject a value', () {
      var controller =
          ControllerMirrorFactory.createMirror(TestController, container)
              .reflectee as TestController;
      expect(controller.secretKey, 'secret');
    });
  });
}
