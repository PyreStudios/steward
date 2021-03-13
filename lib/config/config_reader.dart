import 'dart:io';
import 'package:yaml/yaml.dart';

class ConfigReader {
  File file;
  // @todo: Spooky dynamic
  dynamic parsed;

  ConfigReader({this.file});

  void read() {
    var data = file.readAsStringSync();
    parsed = loadYaml(data);
  }
}
