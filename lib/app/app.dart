class App {

  Router router;

  App({this.router});

  Future start() async {
    var server = await HttpServer.bind(
      InternetAddress.loopbackIPv4,
      4040,
    );

    await for (HttpRequest request in server) {
      // router here though.
      request.response.write('Hello, world!');
      await request.response.close();
    }
  }
}
