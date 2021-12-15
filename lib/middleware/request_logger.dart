import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';


/// An extremely simple Middleware function that prints the incoming request URI
Response? RequestLogger(Request request) {
  print('Incoming Request: ${request.request.uri}');
}