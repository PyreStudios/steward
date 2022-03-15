import 'dart:io';

import 'package:bosun/bosun.dart';
import './new_controller.dart';

var configTemplate = '''---
app:
  name: My Steward App
  port: 4040
''';

var viewTemplate = '''<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.9.1/css/bulma.min.css">
  <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"
    integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
  <link href="https://fonts.googleapis.com/css2?family=Merriweather&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://unpkg.com/aos@next/dist/aos.css" />
  <style>
    @media(max-width: 500px) {
      .reverse-columns {
        flex-direction: column-reverse;
        display: flex;
      }
    }

    .titled {
      font-family: 'Merriweather', serif !important;
      font-size: 58px !important;
      font-weight: 400 !important;
      line-height: 64px !important;
    }

    .subtitled {
      font-family: 'Merriweather', serif !important;
      font-size: 22px !important;
      font-weight: 400 !important;
      line-height: 36px !important;
    }
  </style>
</head>

<body>
  <section class="hero is-white is-fullheight">
    <div class="hero-body">
      <div class="container">
        <div class="columns is-vcentered reverse-columns">
          <div class="column
          is-10-mobile is-offset-1-mobile
          is-10-tablet is-offset-1-tablet
          is-5-desktop is-offset-1-desktop
          is-5-widescreen is-offset-1-widescreen
          is-5-fullhd is-offset-1-fullhd">
            <h1 class="title titled is-1 mb-6">
              Congrats on starting your first Steward app.
            </h1>
            <h2 class="subtitled subtitle has-text-grey is-4 has-text-weight-normal is-family-sans-serif">
              Don't be afraid to check out the documentation for more information.
            </h2>
            <div class="buttons">
              <button class="button is-black">Documentation</button>
              <button class="button">Github</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</body>

</html>
''';

var appTemplate = '''
import 'package:steward/steward.dart';
import 'package:{{{name}}}/controllers/sample_controller.dart';

Future main() async {
  var router = Router();
  router.mount(SimpleController);
  router.get('/hello', handler: (Request request) async {
    return Response.Ok('Hello World!');
  });

  router.get('/config', handler: (Request request) async {
    print(request.container.make('@config.app.name'));
    return Response.Ok(request.container.make('@config.app.name'));
  });

  router.get('/:name', handler: (Request request) async {
    return Response.Ok(request.pathParams['name']);
  });


  // Add your own DI objects to the container here
  var app = App(router: router);

  return app.start();

}
''';

var controllerTemplate = '''import 'package:steward/steward.dart';
import 'package:steward/controllers/route_utils.dart';

class SimpleController extends Controller {
  @Get('/home')
  Response home(Request request) {
    return view('main');
  }
}
''';

class NewCommand extends Command {
  NewCommand()
      : super(
            command: 'new',
            description: 'Create a new steward app',
            example: 'steward new <app-name>',
            subcommands: [NewControllerCommand()]);

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    var name = args[0];

    Process.runSync('dart', ['create', name, '--template', 'console-full']);

    var config = File('./$name/config.yml');
    config.writeAsStringSync(configTemplate);
    Directory('./$name/views').createSync();
    Directory('./$name/lib/controllers').createSync();
    Directory('./$name/assets').createSync();

    // remove generated files from dart tool
    File('$name/lib/$name.dart').deleteSync();
    File('$name/test/${name}_test.dart').deleteSync();

    // write initial files
    File('$name/lib/app.dart')
        .writeAsStringSync(appTemplate.replaceAll('{{{name}}}', name));
    File('$name/lib/controllers/sample_controller.dart')
        .writeAsStringSync(controllerTemplate);
    File('$name/views/main.mustache').writeAsStringSync(viewTemplate);
    Directory.current = Directory('./$name');

    // Add steward to the generated pubspec
    Process.runSync('dart', ['pub', 'add', 'steward']);
    print('Generated new Steward project in directory: $name');
  }
}
