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
