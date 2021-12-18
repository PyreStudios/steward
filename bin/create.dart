import 'package:bosun/bosun.dart';

class CreateCommand extends Command {
  CreateCommand()
      : super(
            command: 'create',
            description:
                'Scaffold out a new item that adheres to the Steward API.',
            example: 'steward create <item>; steward create MyController');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    // TODO: implement run
  }
}
