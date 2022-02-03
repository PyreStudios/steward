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

## Annotations for HTTP Verbs

TODO

## The View function

TODO
