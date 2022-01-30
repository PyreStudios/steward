---
sidebar_position: 1
---

# What is the App
The App class takes care of tying up some odds and ends that many projects may want. For example, registering view files (html/mustache templates) so that they can be used, reading and parsing your config.yml, and -- in the future -- many more items. You don't have to use the App and can get on just fine with just the Router and Container, but if you want these "advanced" features from the framework, then you probably want to use the app.

# Why would I use it?

Like mentioned above, you don't _technically_ have to use the App. In fact, you can make a steward project that **just** uses the router and container, but this is not the recommended way to use steward unless you're building a very small API. Controllers can help structure your logic in a way that can better support code reuse and provide clear intent. The App provides support for registering your view files, reading values from a config, and much more. You're free to use either path when building your app and the plan is to support both, but I'd strongly recommend starting by using the App, especially if this is your first steward project.