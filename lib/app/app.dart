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

  void initializeContainer () {
    container ??= Container();
  }

  void loadConfigIntoContainer() {
    var configFile = File('config.yml');
    var configReader = ConfigReader(file: configFile)..read();
    var config = configReader.parsed;
    var flat = flatten(config);
    flat.entries.forEach((element) {
      container?.bind('@config.'+element.key, (_) => element.value);
    });
  }
}
