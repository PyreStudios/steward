import 'dart:mirrors';

import 'package:steward/controllers/route_utils.dart';
import 'package:steward/steward.dart';
import 'package:test/test.dart';

@Path('/mock_path')
class MockController {
  @Get('/')
  String get() => 'test';

  @Post('/new')
  String post() => 'test';
}

void main() {
  group('RouteUtils', () {
    group('getPaths', () {
      test('should get paths from a class when defined', () {
        final paths = getPaths(reflectClass(MockController));
        expect(paths.first.path, equals('/mock_path/'));
        expect(paths[1].path, equals('/mock_path/new'));
      });
    });

    group('HTTP Verbs', () {
      test('GET should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Get('foo');
        expect(rbd.verb, equals(HttpVerb.Get));
      });

      test('POST should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Post('foo');
        expect(rbd.verb, equals(HttpVerb.Post));
      });

      test('PUT should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Put('foo');
        expect(rbd.verb, equals(HttpVerb.Put));
      });

      test('PATCH should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Patch('foo');
        expect(rbd.verb, equals(HttpVerb.Patch));
      });

      test('DELETE should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Delete('foo');
        expect(rbd.verb, equals(HttpVerb.Delete));
      });

      test('TRACE should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Trace('foo');
        expect(rbd.verb, equals(HttpVerb.Trace));
      });

      test('HEAD should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Head('foo');
        expect(rbd.verb, equals(HttpVerb.Head));
      });

      test('CONNECT should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Connect('foo');
        expect(rbd.verb, equals(HttpVerb.Connect));
      });

      test('OPTIONS should create RouteBindingDecorator properly', () {
        final RouteBindingDecorator rbd = Options('foo');
        expect(rbd.verb, equals(HttpVerb.Options));
      });
    });
  });
}
