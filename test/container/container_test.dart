import 'package:test/test.dart';
import 'package:drengr/drengr.dart';

void main() {
  group('Container tests', () {
    test('should bind and resolve properly', () {
      var container = Container();
      container.bind('key', (Container container) {
        return 'ABC123';
      });

      var key = container.make('key');
      expect(key, 'ABC123');
    });

    test('container items should be able to be built with other container items', () {
      var container = Container();
      container.bind('key', (Container container) {
        return 'ABC';
      });

      container.bind('full_key', (Container container) {
        return container.make('key') + '123';
      });

      expect(container.make('full_key'), 'ABC123');
    });

    test('should throw an exception when an unbound binding is made', () {
      var container = Container();
      expect(() => container.make('key'), throwsNoSuchMethodError);
    });
  });
}


