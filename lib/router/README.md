# Drengr Router

Drengr's router is an essential routing mechanism for the Drengr app, however, you can choose
to use only the router if you prefer a more lightweight development experience.

Drengr's router uses path\_to\_regexp to provide a flexible routing layer.

Here's a quick start example of how you can use the router in a lightweight fashion:

```dart
import 'dart:io';

import 'package:drengr/app/app.dart';
import 'package:drengr/router/router.dart';
import 'package:drengr/router/response.dart';
import 'package:drengr/router/request.dart';

Future main() async {
  var router = Router();
  router.get('/hello', (Request request) {
    return Response.Ok("Hello World!");
  });

  router.get('/:name', (Request request) {
    return Response.Ok(request.pathParams['name']);
  });

  return router.serveHTTP();
}
```
