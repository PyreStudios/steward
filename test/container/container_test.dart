import 'package:test/test.dart';
import 'package:steward/steward.dart';

void main() {
  group('Container tests', () {
    test('should bind and resolve properly', () {
      var container = Container();
      container.bind<String>('key', (Container container) {
        return 'ABC123';
      });

      var key = container.make<String>('key');
      expect(key, 'ABC123');
    });

    test(
        'container items should be able to be built with other container items',
        () {
      var container = Container();
      container.bind<String>('key', (Container container) {
        return 'ABC';
      });

      container.bind<String>('full_key', (Container container) {
        return container.make<String>('key') + '123';
      });

      expect(container.make<String>('full_key'), 'ABC123');
    });

    test('should throw an exception when an unbound binding is made', () {
      var container = Container();
      expect(() => container.make('key'), throwsNoSuchMethodError);
    });
  });
}
