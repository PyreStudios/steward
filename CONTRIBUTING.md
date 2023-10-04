# Contributing to Steward
👍🎉 First off, thanks for taking the time to contribute! 🎉👍

These are mostly guidelines, not rules. Use your best judgment, and feel free to propose changes to this document in a pull request.

## Code of Conduct
All contributions, issues, actions taken, etc. are governed by [Steward's code of conduct](/CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior to brad@pyrestudios.io.

## What do I need to know?

Steward ships as two major modules, the binary module (bin) and the library module (lib).
The binary gets built as an executable and is used to provide a CLI for working with (and generating) Steward projects.

The library module contains all of the code that is used during runtime for applications built ontop of Steward (controllers, router, etc).

# How can I contribute?

## Bug Reports

Does something seem off? Are you seeing crashes that point to our code? Let us know! Bug reports help us isolate issues and ensure that they get fixed in future versions of Steward. Please open an issue and provide as much relevant information as you can (including Operating System, processor architecture, and similar).

## Suggesting Enhancements

Wouldn't it be cool of Steward had an ".explode()" call that wiped your filesystem? Yeah, I didn't think so either, but that doesnt mean we don't want to read your suggestions for the library! Feel free to open an issue to talk through new features or ideas for Steward. Please __do not__ create new Pull Requests for features that haven't been discussed yet. We don't want you to spend your time implementing something that goes against what we believe Steward should be, especially if it won't get accepted.

## Contributing to discussions on issues and pull requests

TODO: Fill these out :)

## Building and Testing Locally

To build Steward and the Steward CLI, you'll need to make sure you've [installed Dart on your machine](https://dart.dev/get-dart).

To build the binary, from the project directory, you can run:

```
dart compile exe ./bin/steward.dart
```

This will create a new executable in the `./bin` directory. You can then access this binary using `./bin/steward.exe {your_commands_here}`. For example, to start a new Steward project named `testeroni` you could run `./bin/steward.exe new testeroni`.

### Running Tests

Steward uses tests to cover some (eventually most) of it's application behavior. Tests are vitally important as they help instill confidence in both the team of contributors as well as the community. It's important to write new tests as we add new functionality and existing tests must pass before changes can be merged in to our main branch.

Tests live in the `tests` folder and can be ran via `dart test` in the root directory. It's important that tests in our main branch always be passing.