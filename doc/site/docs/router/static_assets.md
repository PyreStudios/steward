---
sidebar_position: 5
---

# Static Assets

Steward also offers static asset handlers for serving files that do not change based on server requests. Commonly, image files, html pages, and more are served as static assets. If you are using view templating, those templates are _not_ static assets and should not be served this way.

```dart
final router = Router();
router.staticFiles('/static');
```

Additionally, you can use middleware with static file handling.

```dart
final router = Router();
router.staticFiles('/private-assets', middleware: [RequireAuthMiddleware]);
```
