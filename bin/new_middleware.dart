import 'dart:io';

import 'package:bosun/bosun.dart';
import 'package:recase/recase.dart';

var middlwareTemplate = '''import 'package:steward/steward.dart';

Future<Response> Function(Request) {{{name}}}Middleware(
    Future<Response> Function(Request) next) {
  return (Request request) {

    // Do something here!
    
    return next(request);
  };
}
''';

class NewMiddlewareCommand extends Command {
  NewMiddlewareCommand()
      : super(
            command: 'middleware',
            description: 'Create a new steward middleware',
            example: 'steward new middleware <middleware-name>');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    var name = args[0];
    // write initial files
    final middleware = Directory('./lib/middleware');
    if (!middleware.existsSync()) {
      middleware.createSync();
    }
    File('./lib/middleware/${name.snakeCase}.dart').writeAsStringSync(
        middlwareTemplate.replaceAll('{{{name}}}', name.pascalCase));
  }
}
