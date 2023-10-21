import 'package:steward/container/container.dart';
import 'package:steward/router/router.dart';

abstract interface class Context implements Cloneable, ContainerReable {
  Request get request;
}

class StewardContext implements Context {
  final StewardContainer _container;
  final Request _request;

  StewardContext({StewardContainer? container, required Request request})
      : _container = container ?? StewardContainer(),
        _request = request;

  @override
  StewardContext clone() {
    // TODO: implement clone
    throw UnimplementedError();
  }

  @override
  Request get request => _request;

  @override
  T? read<T>(String key) => _container.read<T>(key);
}
