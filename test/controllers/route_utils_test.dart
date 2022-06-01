import 'dart:mirrors';

import 'package:steward/controllers/route_utils.dart';
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
  });
}
