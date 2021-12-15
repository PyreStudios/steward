import 'package:steward/steward.dart' as steward;
import './help.dart' as help;
import './new.dart' as new_cmd;
import './create.dart' as create_cmd;

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    help.showHelp();
  }

  var action = arguments[0];
  switch (action) {
    case 'new':
      new_cmd.newApp(arguments);
      break;
    case 'create':
      /*create_cmd.create(arguments);*/
      break;
    default:
      help.showHelp();
      break;
  }
}
