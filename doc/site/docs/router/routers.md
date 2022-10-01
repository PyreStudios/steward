---
sidebar_position: 3
---

# The Router

The Router handles setting up request bindings and writing Steward responses to the actual HTTP response.

The router maps the standard HTTP verbs to function names to allocate bindings against that verb. For example, to setup a response binding for a GET requests to "/hello", you would write: `router.get('/hello', (_) => Response.Ok('World'));`

The following verbs are supported:
- GET
- POST
- PATCH
- PUT
- HEAD
- DELETE
- CONNECT
- TRACE
- OPTIONS

## The Handler

The 2nd parameter to each of the Router methods is the handler. The Handler is a function that takes in a Request and should return a Response. At this point, you should be familiar with the Request and Response classes. You can leverage those classes with the Router like so:

```dart
import 'package:steward/steward.dart';

Future main() async {
  var router = Router();
  router.get('/hello', (Request request) async {
    return Response.Ok("Hello World!");
  });

  router.get('/:name', (Request request) async {
    return Response.Ok(request.pathParams['name']);
  });

  return router.serveHTTP();
}
```

## Path Parameters

Router bindings support path parameters, sometimes referred to as dynamic route segments. Path Parameters allow you to effectively pass fields like identifiers in the URL or to have a router that behaves dynamically based on a certain value in the route. 

## Behind the Scenes

Coming soon...