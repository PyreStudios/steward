import 'package:steward/steward.dart' as steward;
import './help.dart' as help;
import './new.dart' as newCmd;
import './create.dart' as createCmd;

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    help.showHelp();
  }

  var action = arguments[0];
  switch (action) {
    case 'new':
      newCmd.newApp(arguments);
      break;
    case 'create':
      /*createCmd.create(arguments);*/
      break;
    default:
      help.showHelp();
      break;
  }
}
