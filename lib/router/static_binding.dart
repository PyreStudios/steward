import 'dart:io';

import 'package:steward/router/router.dart';

class StaticBinding extends RouteBinding {
  StaticBinding({required path, middleware = const []})
      : super(verb: HttpVerb.Get, path: path, middleware: middleware);

  static final imageExtensions = ['png', 'jpeg', 'jpg', 'webp', 'gif'];

  @override
  Future<Response> process(Request request) async {
    var assetPath = request.request.uri.path.split(path).last;
    var assetType = 'text/html';

    try {
      final extension = assetPath.split('.')[0];
      if (imageExtensions.contains(extension)) {
        assetType = 'image/$extension';
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

    final asset = File(assetPath);
    final contents = asset.readAsString();
    final response = Response(200, body: contents);
    final splitAssetType = assetType.split('/');
    final primaryType = splitAssetType.first;
    final subType = splitAssetType.last;
    response.headers.contentType = ContentType(primaryType, subType);

    return response;
  }

  @override
  bool get isPrefixBinding => true;
}
