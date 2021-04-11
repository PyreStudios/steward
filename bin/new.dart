import 'dart:io';

var configTemplate = '''---
app:
  name: My Drengr App
  port: 4040
''';

var viewTemplate = '''<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hello Bulma!</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bulma@0.9.1/css/bulma.min.css">
  </head>
  <body>
  <section class="section">
    <div class="container">
      <h1 class="title">
        Hello World
      </h1>
      <p class="subtitle">
        My first website with <strong>Bulma</strong>!
      </p>
      <p>
        Learn about <a href="./my-favorite-sandwich.html">my favorite sandwich</a>
      </p>
    </div>
  </section>
  </body>
</html>
''';

var appTemplate = '''
import 'package:drengr/app/app.dart';
import 'package:drengr/container/container.dart';
import 'package:drengr/router/router.dart';
import 'package:drengr/router/request.dart';
import 'package:drengr/router/response.dart';

Future main() async {
  var router = Router();
  router.get('/hello', handler: (Request request) {
    return Response.Ok('Hello World!');
  });

  router.get('/config', handler: (Request request) {
    print(request.container);
    print(request.container.make('@config'));
    return Response.Ok(request.container.make('@config'));
  });

  router.get('/:name', handler: (Request request) {
    return Response.Ok(request.pathParams['name']);
  });


  var container = Container();
  // Add your own DI objects to the container here
  var app = App(router: router, container: container);

  return app.start();

}
''';

void newApp(List<String> arguments) {
  if (arguments.length < 2) {
    print('Help coming soon.');
  }

  var name = arguments[1];

  var directory = Directory('$name');
  directory.createSync();

  var config = File('./$name/config.yml');
  config.writeAsStringSync(configTemplate);
  var viewsDir = Directory('$name/views');
  var controllersDir = Directory('$name/controllers');
  var assetsDir = Directory('$name/assets');
  viewsDir.createSync();
  controllersDir.createSync();
  assetsDir.createSync();

  // write initial files
  File('$name/app.dart').writeAsStringSync(appTemplate);
  File('$name/views/main.mustache').writeAsStringSync(viewTemplate);

  print(
      'Generated new Drengr project in directory: ${directory.absolute.path}');
}
