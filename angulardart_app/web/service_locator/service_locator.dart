import 'package:core_app/api/base/local_resource.dart';
import 'package:core_app/service_locator.dart';

import 'web_local_resource.dart';

class ServiceLocator extends CoreServiceLocator {
  @override
  void initialize() {
    super.initialize();

    registerSingleton<CustomLocalResource>(WebLocalResource());
  }
}
