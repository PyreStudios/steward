import 'package:test/test.dart';
import 'package:drengr/container/container.dart';

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
  });
}


