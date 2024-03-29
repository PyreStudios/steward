import 'package:steward/steward.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockRouter extends Fake implements Router {
  @override
  final StewardContainer container;

  MockRouter({required this.container});

  @override
  Future serveHTTP() {
    return Future.value('');
  }
}

void main() {
  group('App', () {
    test('throws exception if cant find config.yml', () async {
      final container = StewardContainer();
      final mockRouter = MockRouter(container: container);
      final app = App(router: mockRouter);

      expect(() async => await app.start(), throwsException);
    });

    test('binds the environment into the application', () async {
      final container = StewardContainer();
      final mockRouter = MockRouter(container: container);
      try {
        // this blows up because the config file is missing
        final app = App(router: mockRouter);
        await app.start();
      } catch (_) {}
      expect(container.read<Environment>('@environment'), Environment.other);
    });
  });
}
