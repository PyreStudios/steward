import 'dart:io';

import 'package:bosun/bosun.dart';
import 'package:recase/recase.dart';

const viewTemplate = '''<!DOCTYPE html>
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
              Congrats on creating your new view.
            </h1>
            <h2 class="subtitled subtitle has-text-grey is-4 has-text-weight-normal is-family-sans-serif">
              Just modify this generated code to create your own view.
            </h2>
          </div>
        </div>
      </div>
    </div>
  </section>
</body>

</html>
''';

class NewViewCommand extends Command {
  NewViewCommand()
      : super(
            command: 'view',
            description: 'Create a new steward view',
            example: 'steward new view <view-name>');

  @override
  void run(List<String> args, Map<String, dynamic> flags) {
    final name = args[0];
    // write initial files
    final views = Directory('./lib/views');
    if (!views.existsSync()) {
      views.createSync();
    }
    File('./lib/views/${name.snakeCase}.dart').writeAsStringSync(
        viewTemplate.replaceAll('{{{name}}}', name.pascalCase));
  }
}
