import 'package:test/test.dart';
import 'package:steward/steward.dart';

void main() {
  group('Container tests', () {
    test('should bind and resolve properly', () {
      var container = StewardContainer();
      container.bind<String>('key', (container) {
        return 'ABC123';
      });

      var key = container.read<String>('key');
      expect(key, 'ABC123');
    });

    test(
        'container items should be able to be built with other container items',
        () {
      var container = StewardContainer();
      container.bind<String>('key', (container) {
        return 'ABC';
      });

      container.bind<String>('full_key', (container) {
        return container.read<String>('key')! + '123';
      });

      expect(container.read<String>('full_key'), 'ABC123');
    });

    test('should return null when an unbound binding is made', () {
      var container = StewardContainer();
      expect(container.read('key'), null);
    });
  });

  group('clone', () {
    test('Clones should have access to the bindings declare before cloning',
        () {
      var container = StewardContainer();
      container.bind('foo', (p0) => 'bar');

      var container2 = container.clone();
      expect(container2.read('foo'), equals('bar'));
    });

    test(
        'updating a binding in a clone should not update the binding for the root',
        () {
      var container = StewardContainer();
      var container2 = container.clone();

      container2.bind('foo', (p0) => 'bar');
      expect(container.read('foo'), equals(null));
    });
  });
}
