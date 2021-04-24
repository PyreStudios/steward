import 'dart:io';

import 'package:drengr/drengr.dart';
import 'package:drengr/controllers/view_not_found_error.dart';
import 'package:test/test.dart';

class TestController extends Controller {}

void main() {
  late TestController controller;
  late Container container;
  setUp(() {
    controller = TestController();
    container = Container();
    controller.setContainer(container);
  });

  group('.view', () {
    test('Returns a response with a content type of HTML', () async {
      container.bind('@views.test_view', (_) => 'Hello World!');
      var response = controller.view('test_view');
      expect(response.headers.contentType, ContentType.html);
    });

    test('Returns a response with mustache vars interpolated', () async {
      container.bind('@views.test_view', (_) => 'Hello {{name}}!');
      var response = controller.view('test_view', varMap: {'name': 'World'});
      expect(response.body, 'Hello World!');
    });

    test('Throws an error when the view cant be found', () async {
      expect(() => controller.view('unknown_view'), throwsA(TypeMatcher<ViewNotFoundError>()));
    });
  });
}
