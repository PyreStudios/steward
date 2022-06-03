---
sidebar_position: 6
---

# Containerizing a Steward App

There are many examples of setting up a dockerfile for AoT compiled Dart. Unfortunately, AoT compiled Dart does not support reflection on which Steward relies heavily. We've put together a simple Dockerfile to help with this process.

```dockerfile
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:2.17
ENV HOMEDIR=/manudac
# Resolve app dependencies.
WORKDIR /app

# Copy app source code
COPY . .

RUN rm /app/pubspec.lock
RUN rm -rf .dart_tool
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --no-offline
RUN dart pub update

# Start server.
EXPOSE 4040
CMD ["dart", "run", "lib/app.dart"]
```

The important thing to note is that the `.dart_tool/` folder has references to your local machine paths (if you've ran the app outside of a container). `dart` will use these references when trying to compile and the references in this file point to code outside of your project directory (your user's pubcache for example). For this reason, we delete the `.dart_tool/` folder after copying everything over.

If you're running your steward app with docker-compose or a similar tool, you'll need to make sure that any volumes that you're mounting do _not_ mount the `.dart_tool/` folder, too.

## Should you dockerize/containerize your app?

Yes. Containerization significantly eases deployments on modern cloud infrastructure. You will have a significantly easier time trying to deploy a container with your app than your code directly. All major cloud providers support running containers at scale, almost none of them provide first-class support for running Dart outside of containers.

Additionally, having your app containerized for development helps reduce the hurdles for developing on that app. 