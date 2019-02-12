import 'package:flutter/material.dart';
import 'package:flutter_app/flutter_app.dart';
import 'package:flutter_app/service_locator.dart';

void main() {
  ServiceLocator().initialize();
  runApp(FlutterApp());
}
