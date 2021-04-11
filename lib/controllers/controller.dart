import 'package:drengr/container/container.dart';
import 'package:mustache_template/mustache.dart';
import 'package:drengr/router/response.dart';

abstract class Controller {

  late Container container;
  
  Response view(String filename, Map<String, dynamic> varMap) {
    // get the pre-loaded template string out of the container
    var template = Template("{{ author.name }}");
    var output = template.renderString(varMap);
    return Response.Ok(output);
  }
}
