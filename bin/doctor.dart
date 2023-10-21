import 'dart:io';

import 'package:bosun/bosun.dart';

class DoctorCommand extends Command {
  DoctorCommand()
      : super(
            command: 'doctor',
            description:
                'Validates a steward application and prints out any relevant data associated with it',
            example: 'steward doctor');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    final configExists = File('./config.yml').existsSync();
    final viewsExist = Directory('./views').existsSync();
    final pubspec = File('./pubspec.yaml');
    final pubspecExists = pubspec.existsSync();
    final pubspecContents = pubspecExists ? pubspec.readAsLinesSync() : [];
    final stewardVersion = pubspecContents.firstWhere(
        (element) => element.contains('steward:'),
        orElse: () => 'NOT FOUND');

    print('''
  -----------------------
  Steward Doctor
  -----------------------
  Pubspec Version: $stewardVersion
  -----------------------
  has views folder: $viewsExist
  has config: $configExists
''');
  }
}
