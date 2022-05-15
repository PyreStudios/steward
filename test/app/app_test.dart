import 'package:steward/steward.dart';
import 'package:test/test.dart';
import 'package:mockito/mockito.dart';

class MockRouter extends Fake implements Router {
  @override
  final Container container;

  MockRouter({required this.container});

  @override
  Future serveHTTP() {
    return Future.value('');
  }
}

void main() {
  group('App', () {
    test('throws exception if cant find config.yml', () async {
      final container = CacheContainer();
      final mockRouter = MockRouter(container: container);
      final app = App(router: mockRouter);

      expect(() async => await app.start(), throwsException);
    });

    // test('binds the environment into the application', () async {
    //   final container = CacheContainer();
    //   final mockRouter = MockRouter(container: container);

    //   // when(mockRouter.serveHTTP()).thenAnswer((_) => Future.value(''));
    //   // when(mockRouter.container).thenReturn(container);

    //   final app = App(router: mockRouter);

    //   await app.start();

    //   expect(container.make<Environment>('@environment'), Environment.other);
    // });
  });
}
