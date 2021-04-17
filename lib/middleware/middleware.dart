import 'package:drengr/router/request.dart';
import 'package:drengr/router/response.dart';

typedef MiddlewareFunc = Response? Function(Request);
