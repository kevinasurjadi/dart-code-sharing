
import 'package:async_resource/async_resource.dart';
import 'package:async_resource/browser_resource.dart';
import 'package:core_app/api/base/local_resource.dart';

class WebLocalResource implements CustomLocalResource {
  @override
  LocalResource<String> getResourceInstance(String key) {
    return StorageEntry<String>(key, saveLastModified: true);
  }
}