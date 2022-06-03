---
sidebar_position: 1
---

# Requests

Steward handles incoming HTTP requests by mapping them to a Request class.
This class functions as a wrapper of the HTTPRequest from 'dart:io', but also adds additional properties that are used by the Steward framework (and exposes a few extra properties for you to leverage, too!).

Most of the time, you won't need to new up a request directly as you'll let Steward handle that for you, however, you may want to instantiate requests when writing tests (and this is completely supported).

### Getting Values for Path Parameters

When Steward's Router processes a request, it will parse and attach certain metadata from the request for each of access. Namely, you can pull path parameters out of a request object. We'll talk more about how these get _into_ a request object when we cover the router, but for now, just know that you can retrieve path parameters from a request by access the `pathParams` property on that request.

```dart
Request myRequest = getARequestFromSomewhere();
print(myRequest.pathParams);
```