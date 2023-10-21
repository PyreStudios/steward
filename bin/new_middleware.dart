import 'dart:io';

import 'package:bosun/bosun.dart';
import 'package:recase/recase.dart';

const middlwareTemplate = '''import 'package:steward/steward.dart';

Future<Response> Function(Context) {{{name}}}Middleware(
    Future<Response> Function(Context) next) {
  return (Context context) {

    // Do something here!
    
    return next(context);
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
    final name = args[0];
    // write initial files
    final middleware = Directory('./lib/middleware');
    if (!middleware.existsSync()) {
      middleware.createSync();
    }
    File('./lib/middleware/${name.snakeCase}.dart').writeAsStringSync(
        middlwareTemplate.replaceAll('{{{name}}}', name.pascalCase));
  }
}
