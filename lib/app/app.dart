import 'dart:io';
import 'package:flat/flat.dart';

import 'package:steward/router/router.dart';
import 'package:steward/container/container.dart';
import 'package:steward/config/config_reader.dart';

class AppConfigurationException implements Exception {}

class App {
  Router router;
  late Container container;

  App({required this.router});

  Future start() async {
    initializeContainer();
    _loadConfigIntoContainer();
    _loadViewsIntoContainer();

    return await router.serveHTTP();
  }

  /// Create a container for us if one is not in scope
  void initializeContainer() {
    container = router.container;
  }

  /// Loads and parses the config file, then flattens the config map
  /// and ultimately preprends "@config." to the key before adding that
  /// config item to the DI container.
  void _loadConfigIntoContainer() {
    var configFile = File('config.yml');
    var configReader = ConfigReader(file: configFile)..read();
    var config = configReader.parsed;
    var flat = flatten(config);
    flat.entries.forEach((element) {
      container.bind('@config.' + element.key, (_) => element.value);
    });
  }

  void _loadViewsIntoContainer() {
    try {
      var files = Directory('./views')
          .listSync(recursive: true, followLinks: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.mustache'))
          .map((file) =>
              {'path': file.path, 'contents': file.readAsStringSync()});
      files.forEach((file) {
        var key = file['path']
            ?.replaceAll('/', '.')
            .replaceFirst('..views.', '')
            .replaceFirst('.mustache', '');
        container.bind('@views.$key', (_) => file['contents']);
      });
    } catch (e) {
      print(
          'Failed to load views. Please ensure that there is a `views` subfolder in your application.');
    }
  }
}
