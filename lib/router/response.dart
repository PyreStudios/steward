import 'dart:io';

class Headers {
  ContentType contentType = ContentType.json;
  DateTime? date = DateTime.now();

  Headers();
}

class Response {
  int statusCode;
  Headers headers = Headers();
  // this could be anything!
  dynamic body;

  Response(this.statusCode, {this.body});

  Response.Ok(dynamic body) :
    this(HttpStatus.ok, body: body);

  Response.Created(dynamic body) :
    this(HttpStatus.created, body: body);

  Response.BadRequest(dynamic body) :
    this(HttpStatus.badRequest, body: body);

  Response.Unauthorized(dynamic body) :
    this(HttpStatus.unauthorized, body: body);

  Response.Forbidden(dynamic body) :
    this(HttpStatus.forbidden, body: body);

  Response.NotFound(dynamic body) :
    this(HttpStatus.notFound, body: body);

  Response.InternalServerError(dynamic body) :
    this(HttpStatus.internalServerError, body: body);

  Response.Boom(dynamic body) :
    this(HttpStatus.internalServerError, body: body);
}
