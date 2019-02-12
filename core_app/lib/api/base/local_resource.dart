import 'package:async_resource/async_resource.dart';

abstract class CustomLocalResource {
  LocalResource getResourceInstance(String key);
}
