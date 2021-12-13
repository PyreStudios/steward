import 'dart:io';

import 'package:steward/controllers/view_not_found_error.dart';
import 'package:steward/container/container.dart';
import 'package:mustache_template/mustache.dart';
import 'package:steward/router/response.dart';

abstract class Controller {

  late Container container;

  Response view(String filename, {Map<String, dynamic> varMap = const {}}) {
    var templateString = '';
    try {
      templateString = container.make('@views.$filename');
    } catch (e) {
      throw ViewNotFoundError(filename);
    }
    var template = Template(templateString);
    var output = template.renderString(varMap);
    return Response.Ok(output)..headers.contentType = ContentType.html;
  }

  void setContainer(Container container) {
    this.container = container;
  }
}
