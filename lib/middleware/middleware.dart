import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';

typedef MiddlewareFunc = Response? Function(Request);
