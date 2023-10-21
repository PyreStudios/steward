---
sidebar_position: 1
---

# What is a Container

A container, in the Steward sense, is simply a box that things can be stored in and retrieved from. In our case, we use our Container as the foundation for our dependency injection framework. The container should be one of the simpest things about Steward. You can put key-value pairs into it, and you can select values by their key.

# DI in a Nutshell
Simply put, DI (Dependency Injection) is a technique in which an object recieves other objects that it depends on. There are typically three main names used to identify DI components. A "Client" is the object that dependencies are being provided to, an injected object is often (but not always) called a "Service", and finally the code that passes the Service into the Client is called an "Injector."

The intent behind DI is to provide a separation of concerns when it comes to constructing objects.

# Binding a "Service" to the DI Container
Let's start by binding a "Service" to the DI container.

```dart
final container = Container();
container.bind<String>('sample', (Container container) {
  return 'ABC123';
});
```

This simple snippet shows how we can new up an implementer of Container (CacheContainer is what Steward ships with but you can provide your own!). Then, we bind a String value (the generic specifies the type of the Value returned) to the key of 'sample.' The second parameter is called a binding function. The reason we use a function for binding is that it allows us to access previously bound "Services" in the container when creating our new binding. Finally, the binding function returns a String (in our case, the "key" of 'ABC123').

# Getting a value from a Container

Let's bind the same value from above:

```dart
final container = StewardContainer();
container.bind<String>('sample', (Container container) {
  return 'ABC123';
});
```

Now we'll likely want to retrieve this String from our container at some point. Doing so is fairly simple!

```dart
final key = container.make<String>('sample');
// key is now 'ABC123'
```

# Complex Values
The CacheContainer (that ships with Steward) keeps everything in memory by default. This allows us to store complex values (like objects) in the container as well.

```dart
class UserService {
  static Key = 'UserService';
  String loggedInID;

  UserService(this.loggedInID);
}


final container = StewardContainer();
container.bind<UserService>(UserService.Key, (Container container) {
  return UserService('1');
});

container.make<UserService>(UserService.Key).loggedInID;
// 1
```

# How to get a Container
The Router uses a container behind the scenes and news one up when you new up a router. You can access this via the container property on the router, or you can provide your own container to the router by calling `router.setContainer(myContainer)`. Its important to know that the Steward framework uses the container that's on the router. Binding items to your container but not setting that as the router's container is effectively useless.