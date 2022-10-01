---
sidebar_position: 1
---

# Controllers

Controllers are responsible for controlling the way that a user interacts with your server-side application. Steward provides a Controller that your own Controllers can extend, which provides a few key benefits for you to leverage.

```dart
class SampleController extends Controller {
  @Injectable('UserService')
  late UserService userService;
  
  @Get('/version')
  version(_) => 'v1.0';

  @Get('/show')
  Response show(Request request) => view('main_template');
  
  @Get('/users')
  Response users => UserService.getUsers();
}
```

The controller in this example is a SampleController that extends the Controller provided by Steward. Additionally, this controller specifies that a UserService should be injected from the DI container, a GET handler to '/version' that returns 'v1.0', a GET handler to '/show' that renders a view, and a GET handler to '/users' that gets data from the injected UserService. This probably isn't the best example of a real-life controller, but it showcases a lot of functionality.

## A note on async
Controller functions can be either sync or async! It's entirely up to you and Steward supports both!

Controller methods can be set up to return a `Response` or a `Future<Response>`. Generally, most controller methods tend to become async over time and for that reason, we encourage using async as a default but if you find that its overly complicating something (say returning a static string to indicate a healthcheck or a version number perhaps).


## Annotations for HTTP Verbs

Controllers are reflectively mounted using annotations. Specifically, Steward provides a list of HTTP verbs as annotations that can be used to decorate method handlers. Note: Mounting a controller to your router without any HTTP Verb annotations will generate no routes.

These annotations also take in an optional list of middleware to run against that method. A great example might be to guard specific routes with authentication middleware. To do so at the controller level, we can modify our above example like so:

```dart
class SampleController extends Controller {
  @Injectable('UserService')
  late UserService userService;
  
  @Get('/version')
  version(_) => 'v1.0';

  @Get('/show', [userHasAccessMiddleware])
  Response show(Request request) => view('main_template');
  
  @Get('/users', [userHasAccessMiddleware])
  Response users => UserService.getUsers();
}
```

This assumes that you have a middleware named `userHasAccessMiddleware` in scope of this file. You'll want to substitute the name of your own middleware instead of using that one.

## The Path Annotation

The Path annotation can be applied to a class that extends `Controller` and allows you to set up the "root" path for that controller. Let's add a path annotation to the previous example:

```dart
@Path('/sample')
class SampleController extends Controller {
  @Injectable('UserService')
  late UserService userService;
  
  @Get('/version')
  version(_) => 'v1.0';

  @Get('/show', [userHasAccessMiddleware])
  Response show(Request request) => view('main_template');
  
  @Get('/users', [userHasAccessMiddleware])
  Response users => UserService.getUsers();
}
```

If the server were running on localhost:1234, mounting this controller into the router would create the following routes:
- localhost:1234/sample/version
- localhost:1234/sample/show
- localhost:1234/sample/users

Additionally, middleware can be added to the Path parameter, too. This is effectively the same thing as applying the middleware individually to _all_ of the routes under that path. For example, we can add the `userHasAccessMiddleware` to the `@Path` declaration, but it would also apply to the `@Get('/version')` declaration, too. A common example of when you may use this is to add controller-level middleware such as a controller specific logger or guarding access to all controller properties if a user is not logged in.

```dart
@Path('/sample', [userHasAccessMiddleware])
class SampleController extends Controller {
  @Injectable('UserService')
  late UserService userService;
  
  @Get('/version')
  version(_) => 'v1.0';

  @Get('/show')
  Response show(Request request) => view('main_template');
  
  @Get('/users')
  Response users => UserService.getUsers();
}
```

## The View function

The view function is provided by the Controller class. It can be used to generate a response with an HTML body from one of the mustache templates in your views directory.

Assuming we have a view in a file called `all_records`, we could write:

```dart
class MyController extends Controller {

  @Get('/index')
  Response showItems() {
    // any variables needed by the template can be passed in to varMap.
    return view('all_records', varMap: {
      'name': 'Steward'
    });
  }
}

```