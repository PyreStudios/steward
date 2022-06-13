---
sidebar_position: 2
---

# Responses

To write data in response to an HTTP Request, Steward uses Responses. The Response class has many constructors to help you model your Response accurately and expressively in code. For example, if you wanted to create a Response to model a status code 200 response with a body of "Hello World", you could write `Response.Ok("Hello World")`.

This table below shows the supported shorthands.

| Constructor                  | Status Code |
|------------------------------|-------------|
| Response.Ok                  | 200         |
| Response.Created             | 201         |
| Response.BadRequest          | 400         |
| Response.Unauthorized        | 401         |
| Response.Forbidden           | 403         |
| Response.NotFound            | 404         |
| Response.InternalServerError | 500         |
| Response.Boom                | 500         |

Additionally, if you'd like to return a status code that is not supported via the auxillary constructors, you can always use the primary constructor which takes in a status code as an int.

```dart
// Generate an I'm a Teapot Response
Response teapot = Response(418, body: 'No coffee for you!');
```

## Accessing Response Headers

Once a Response has been created, you can modify the Response headers.

```dart
// Generate an I'm a Teapot Response
Response teapot = Response(418, body: 'No coffee for you!');
teapot.headers.set('Coffee', 'Nope');
```

## Inferring Content Type
By Default, Steward will attempt to infer the content type of your response. If you have not provided a content type and the body looks like JSON, we'll automatically set the content type to application/json. We'll do the same thing for text content. If you don't want steward to infer content types, you can explicitly set them when you new up a response.