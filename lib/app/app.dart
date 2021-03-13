import 'dart:io';

import 'package:drengr/router/router.dart';
import 'package:drengr/container/container.dart';

class AppConfigurationException implements Exception {}

class App {

  Router router;
  Container container;

  App({this.router, this.container});

  Future start() async {
    router.container ??= container;

    if (router != null) {
      return await router.serveHTTP();
    } else {
      throw AppConfigurationException();
    }
  }
}
