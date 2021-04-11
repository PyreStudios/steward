import 'dart:io';
import 'package:flat/flat.dart';

import 'package:drengr/router/router.dart';
import 'package:drengr/container/container.dart';
import 'package:drengr/config/config_reader.dart';


class AppConfigurationException implements Exception {}

class App {

  Router router;
  Container? container;

  App({required this.router, this.container});

  Future start() async {
    initializeContainer();
    loadConfigIntoContainer();

    router.container ??= container;

    return await router.serveHTTP();
  }

  /// Create a container for us if one is not in scope
  void initializeContainer () {
    container ??= Container();
  }

  /// Loads and parses the config file, then flattens the config map
  /// and ultimately preprends "@config." to the key before adding that
  /// config item to the DI container.
  void loadConfigIntoContainer() {
    var configFile = File('config.yml');
    var configReader = ConfigReader(file: configFile)..read();
    var config = configReader.parsed;
    var flat = flatten(config);
    flat.entries.forEach((element) {
      container?.bind('@config.'+element.key, (_) => element.value);
    });
  }

  void loadViewsIntoContainer() {
    var files = Directory('./views')
      .listSync(recursive: true, followLinks: true)
      .where((entity) => entity is File)
      .where((file) => file.path.endsWith('.mustache'))
      .map((file) => {
        'path': file.path,
        'contents': (file as File).readAsStringSync()
      });
    files.forEach((file) {
      container?.bind('@view.${file["path"]}', (_) => file['contents']);
    });
  }
}
