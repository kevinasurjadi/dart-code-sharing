import 'package:async_resource/async_resource.dart';
import 'package:async_resource_flutter/async_resource_flutter.dart';
import 'package:core_app/api/base/local_resource.dart';
import 'package:core_app/core.dart';

class FlutterLocalResource implements CustomLocalResource {
  @override
  LocalResource<String> getResourceInstance(String key) {
    return StringMmkvResource(key, saveLastModified: true);
  }
}
