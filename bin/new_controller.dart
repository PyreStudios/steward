import 'dart:io';

import 'package:bosun/bosun.dart';
import 'package:recase/recase.dart';

var controllerTemplate = '''import 'package:steward/steward.dart';
class {{{name}}} extends Controller {
  @Get('/home')
  Response home(Request request) {
    return view('main');
  }
}
''';

class NewControllerCommand extends Command {
  NewControllerCommand()
      : super(
            command: 'controller',
            description: 'Create a new steward controller',
            example: 'steward new controller <controller-name>');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    var name = args[0];
    // write initial files
    File('./lib/controllers/${name.snakeCase}.dart').writeAsStringSync(
        controllerTemplate.replaceAll('{{{name}}}', name.pascalCase));
  }
}
