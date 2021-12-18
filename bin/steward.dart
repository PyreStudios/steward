import 'package:steward/steward.dart' as steward;
import './help.dart' as help;
import './new.dart' as new_cmd;
import './create.dart' as create_cmd;
import 'package:bosun/bosun.dart' as bosun;

void main(List<String> arguments) {
  bosun.execute(bosun.BosunCommand('steward', subcommands: []), arguments);
}
