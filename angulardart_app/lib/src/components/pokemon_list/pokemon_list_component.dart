import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angulardart_app/src/components/base/base_component.dart';
import 'package:core_app/core.dart';

@Component(
  selector: 'pokemon-list',
  templateUrl: 'pokemon_list_component.html',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'pokemon_list_component.css',
  ],
  directives: [
    coreDirectives,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialSpinnerComponent,
    BaseComponent,
  ],
  providers: [
    ClassProvider(PokemonRepo),
    ClassProvider(PokemonListBloc),
    ExistingProvider(BaseBloc, PokemonListBloc),
  ],
  pipes: [
    commonPipes,
  ]
)
class PokemonListComponent implements OnDestroy {
  final PokemonListBloc pokemonBloc;

  PokemonListComponent(this.pokemonBloc);

  @override
  void ngOnDestroy() {
    pokemonBloc.dispose();
  }

}