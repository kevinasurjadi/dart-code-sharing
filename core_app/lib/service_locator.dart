import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

class CoreServiceLocator {
  static GetIt instance = GetIt();

  @mustCallSuper
  void initialize() {}

  @mustCallSuper
  void reset() => instance.reset();

  void registerSingleton<T>(T obj) {
    instance.registerSingleton<T>(obj);
  }
}
