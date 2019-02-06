import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:core_app/core.dart';

@Component(
  selector: 'base-component',
  templateUrl: 'base_component.html',
  styleUrls: ['base_component.css'],
  directives: [
    coreDirectives,
    MaterialButtonComponent,
    MaterialSpinnerComponent,
    MaterialDialogComponent,
    ModalComponent,
  ],
  pipes: [
    commonPipes,
  ],
  providers: [
    overlayBindings,
  ],
)
class BaseComponent {
  BaseBloc baseBloc;
  BaseComponent(this.baseBloc);
}