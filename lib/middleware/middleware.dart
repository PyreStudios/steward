import 'package:steward/router/router.dart';

/// MiddlewareFunc is a typedef that describes what a middleware function looks like.
/// The main takeaway here is that this function takes in the next handler in the chain
/// and returns a handlerm itself.
/// This might sound confusing, but the implementation for this middleware pattern
/// is likely not as bad as you may think! Check out the documentation for more
/// information.
typedef MiddlewareFunc = Future<Response> Function(Context) Function(
    Future<Response> Function(Context) nextHandler);
