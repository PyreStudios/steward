import 'dart:io';
import 'package:flat/flat.dart';

import 'package:steward/router/router.dart';
import 'package:steward/container/container.dart';
import 'package:steward/config/config_reader.dart';

class AppConfigurationException implements Exception {}

enum Environment { production, other }

class App {
  Router router;
  Environment environment;
  late StewardContainer _container;

  App({required this.router, this.environment = Environment.other}) {
    _container = router.container;
  }

  /// Start ultimate runs `router.serverHTTP` but unlike simply calling
  /// `router.serverHTTP`, `start` will also bind the environment into the DI container,
  /// load the config.yml file into the container, and load all view templates into the container.
  /// This is the recommended way to start the app.
  ///
  /// In the future, more functionality may be added to the `start` method.
  Future start() async {
    _bindEnvironmentIntoContainer();
    _loadConfigIntoContainer();
    _loadViewsIntoContainer();

    return await router.serveHTTP();
  }

  void _bindEnvironmentIntoContainer() {
    _container.bind('@environment', (_) => environment);
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
      _container.bind('@config.' + element.key, (_) => element.value);
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
        _container.bind('@views.$key', (_) => file['contents']);
      });
    } catch (e) {
      print(
          'Failed to load views. Please ensure that there is a `views` subfolder in your application.');
    }
  }
}
