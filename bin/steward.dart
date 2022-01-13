import './new.dart' as new_cmd;
import 'package:bosun/bosun.dart' as bosun;

void main(List<String> arguments) {
  bosun.execute(
      bosun.BosunCommand('steward', subcommands: [new_cmd.NewCommand()]),
      arguments);
}
