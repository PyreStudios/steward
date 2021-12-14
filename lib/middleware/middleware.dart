import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';

typedef Handler = Response Function(Request);
typedef MiddlewareFunc = Handler Function(Handler nextHandler);
