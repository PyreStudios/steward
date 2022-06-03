---
sidebar_position: 3
---

# Views

The app is responsible for many things, but one important task that it accomplishes is registering the views for your application. 

Views live in the `/views` folder under your Steward app and are mustache files. Most interactions with Views will come from the `view` method on the controller class, but you're free to work with them on your own as well. That being said, we strongly encourage you to either use controllers or build an abstraction around this work. This behavior may change at a later date.

When the app starts, it will scan the `/views` file directory and mount those items into the DI container.

For more information on how to work with views, please see the controller documentation.