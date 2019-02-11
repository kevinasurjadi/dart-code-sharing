import 'package:angular/angular.dart';
import 'package:angulardart_app/app_component.template.dart' as ng;

import 'service_locator.dart';

void main() {
  ServiceLocator().initialize();
  runApp(ng.AppComponentNgFactory);
}
