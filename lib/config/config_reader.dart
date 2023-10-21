import 'dart:io';
import 'dart:convert';
import 'package:yaml/yaml.dart';

/// Parses Yaml config files and converts them into Map objects.
class ConfigReader {
  File file;

  Map<String, dynamic> parsed = {};

  ConfigReader({required this.file});

  /// Reads the config file and parses it into a Map.
  void read() {
    final data = file.readAsStringSync();
    YamlMap yamlMap = loadYaml(data);
    // hacky way to go from yaml map to normal map
    parsed = jsonDecode(jsonEncode(yamlMap));
  }
}
