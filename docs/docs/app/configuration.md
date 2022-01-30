---
sidebar_position: 2
---

# Configuration

The app is responsible for parsing your Steward configuration file and binding that to the DI container. Nested structures will be flattened when generating keys. This means a config YAML like this:

```yml
---
app:
  name: My Steward App
  port: 4040
```

Will generate a key at `@config.app.name` and `@config.app.port`. At this point in time, you can not reference partial flattened keys (no `@config.app` in the above example).

You're free to put whatever you want in your configuration file. The convention is too create a new root level key and assign items under that. This helps prevent conflicts with the required steward keys and helps better organize code. Please see the following as an example.

```yml
---
app:
  name: My Steward App
  port: 4040

db:
  driver: postgres
  database: my_db
  user: my_user
```