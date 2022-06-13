import 'package:test/test.dart';
import 'package:steward/steward.dart';

void main() {
  group('Container tests', () {
    test('should bind and resolve properly', () {
      var container = CacheContainer();
      container.bind<String>('key', (Container container) {
        return 'ABC123';
      });

      var key = container.make<String>('key');
      expect(key, 'ABC123');
    });

    test(
        'container items should be able to be built with other container items',
        () {
      var container = CacheContainer();
      container.bind<String>('key', (Container container) {
        return 'ABC';
      });

      container.bind<String>('full_key', (Container container) {
        return container.make<String>('key')! + '123';
      });

      expect(container.make<String>('full_key'), 'ABC123');
    });

    test('should return null when an unbound binding is made', () {
      var container = CacheContainer();
      expect(container.make('key'), null);
    });
  });

  group('clone', () {
    test('Clones should have access to the bindings declare before cloning',
        () {
      var container = CacheContainer();
      container.bind('foo', (p0) => 'bar');

      var container2 = container.clone();
      expect(container2.make('foo'), equals('bar'));
    });

    test(
        'updating a binding in a clone should not update the binding for the root',
        () {
      var container = CacheContainer();
      var container2 = container.clone();

      container2.bind('foo', (p0) => 'bar');
      expect(container.make('foo'), equals(null));
    });
  });
}
