import 'package:steward/router/request.dart';
import 'package:steward/router/response.dart';

/// Handler typedef for what a middleware handler function looks like
typedef Handler = Response Function(Request);

/// MiddlewareFunc is a typedef that describes what a middleware function looks like.
/// The main takeaway here is that this function takes in the next handler in the chain
/// and returns a handlerm itself.
/// This might sound confusing, but the implementation for this middleware pattern
/// is likely not as bad as you may think! Check out the documentation for more
/// information.
typedef MiddlewareFunc = Handler Function(Handler nextHandler);
