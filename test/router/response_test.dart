import 'package:steward/router/response.dart';
import 'package:test/test.dart';

void main() {
  group('Headers', () {
    group('set', () {
      final headers = Headers();
      test('sets values as expected', () async {
        headers.set('key', ['value']);
        expect(headers['key'], equals(['value']));
      });
    });

    group('add', () {
      final headers = Headers();

      test('adds values as expected to existing keys', () async {
        headers.add('new_key', ['value1']);
        expect(headers['new_key'], equals(['value1']));
      });

      test('adds values as expected to existing keys', () async {
        headers.set('key', ['value']);
        expect(headers['key'], equals(['value']));
        headers.add('key', ['value2']);
        expect(headers['key'], equals(['value', 'value2']));
      });
    });
  });
}
