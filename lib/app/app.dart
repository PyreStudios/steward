import 'dart:io';

import 'package:drengr/router/router.dart';
import 'package:drengr/container/container.dart';
import 'package:drengr/config/config_reader.dart';

class AppConfigurationException implements Exception {}

class App {

  Router router;
  Container container;

  App({this.router, this.container});

  Future start() async {
    initializeContainer();
    loadConfigIntoContainer();

    router.container ??= container;

    if (router != null) {
      return await router.serveHTTP();
    } else {
      throw AppConfigurationException();
    }
  }

  void initializeContainer () {
    container ??= Container();
  }

  void loadConfigIntoContainer() {
    var configFile = File('./config.yml');
    var configReader = ConfigReader(file: configFile);
    var config = configReader.parsed;
    container?.bind('@config', (_) => config);
  }
}
