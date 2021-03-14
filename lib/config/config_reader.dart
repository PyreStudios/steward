import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';

class ConfigReader {
  File file;

  Map<String, Object> parsed = {};

  ConfigReader({required this.file});

  void read() {
    var data = file.readAsStringSync();
    YamlMap yamlMap = loadYaml(data);
    // hacky way to go from yaml map to normal map
    parsed = jsonDecode(jsonEncode(yamlMap));
  }
}
