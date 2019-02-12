import 'package:core_app/core.dart';
import 'package:flutter_app/api/local_resource.dart';

class ServiceLocator extends CoreServiceLocator {
  @override
  void initialize() {
    super.initialize();

    registerSingleton<CustomLocalResource>(FlutterLocalResource());
  }
}
