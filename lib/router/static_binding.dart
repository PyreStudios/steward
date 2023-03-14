import 'dart:io';

import 'package:steward/router/router.dart';

class StaticBinding extends RouteBinding {
  StaticBinding({required super.path, super.middleware})
      : super(verb: HttpVerb.Get);

  static final imageExtensions = ['png', 'jpeg', 'jpg', 'webp', 'gif'];
  static final textExtensions = ['css', 'csv', 'html', 'xml'];

  @override
  Future<Response> process(Request request) async {
    var assetPath = '$path${request.request.uri.path.split(path).last}';
    var assetType = 'text/html';

    print(assetPath);
    try {
      final extension = assetPath.split('.').last;
      if (imageExtensions.contains(extension)) {
        assetType = 'image/$extension';
      }
      if (textExtensions.contains(extension)) {
        assetType = 'text/$extension';
      } else {
        // TODO: this is probably to vague
        assetType = 'application/$extension';
      }
    } on StateError {
      // if there is no extension, assume text/html.
      assetType = 'text/html';
    }

    if (assetType == 'text/html' && !assetPath.contains('.')) {
      assetPath = '$assetPath.html';
    }

    try {
      final asset = File('./$assetPath');
      final contents = await asset.readAsString();
      final response = Response(200, body: contents);
      final splitAssetType = assetType.split('/');
      final primaryType = splitAssetType.first;
      final subType = splitAssetType.last;
      response.headers.contentType = ContentType(primaryType, subType);

      print(response);

      return response;
    } catch (e) {
      return Response.NotFound();
    }
  }

  @override
  bool get isPrefixBinding => true;
}
