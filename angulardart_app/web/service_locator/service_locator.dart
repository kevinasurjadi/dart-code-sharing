import 'package:core_app/core.dart';

import 'web_local_resource.dart';

class ServiceLocator extends CoreServiceLocator {
  @override
  void initialize() {
    super.initialize();

    registerSingleton<CustomLocalResource>(WebLocalResource());
  }
}
