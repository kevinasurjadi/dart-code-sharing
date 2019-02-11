import 'package:async_resource/async_resource.dart';
import 'package:core_app/api/base/local_resource.dart';
import 'package:core_app/service_locator.dart';
import 'package:async_resource/browser_resource.dart';

class ServiceLocator extends CoreServiceLocator {
  @override
  void initialize() {
    super.initialize();

    registerSingleton<CustomLocalResource>(WebLocalResource());
  }
}

class WebLocalResource implements CustomLocalResource {
  @override
  LocalResource<String> getResourceInstance(String key) {
    return StorageEntry<String>(key, saveLastModified: true);
  }
}
