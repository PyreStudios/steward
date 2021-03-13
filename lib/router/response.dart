import 'dart:io';

class Response {
  int statusCode;
  Map<String, dynamic> headers;
  // this could be anything!
  dynamic body;

  Response(this.statusCode, {this.headers, this.body});

  Response.Ok(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.ok, headers: headers, body: body);

  Response.Created(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.created, headers: headers, body: body);

  Response.BadRequest(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.badRequest, headers: headers, body: body);

  Response.Unauthorized(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.unauthorized, headers: headers, body: body);

  Response.Forbidden(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.forbidden, headers: headers, body: body);

  Response.NotFound(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.notFound, headers: headers, body: body);

  Response.InternalServerError(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.internalServerError, headers: headers, body: body);

  Response.Boom(dynamic body, {Map<String, dynamic> headers}) :
    this(HttpStatus.internalServerError, headers: headers, body: body);
}
