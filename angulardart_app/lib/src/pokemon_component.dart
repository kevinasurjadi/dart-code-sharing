import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/material_list/material_list.dart';
import 'package:angular_components/material_list/material_list_item.dart';
import 'package:angular_components/material_spinner/material_spinner.dart';
import 'package:pokemon_dart/bloc.dart';
import 'package:pokemon_dart/repo/model.dart';
import 'package:pokemon_dart/repo/repo.dart';

@Component(
  selector: 'pokemon-component',
  templateUrl: 'pokemon_component.html',
  styleUrls: [
    'package:angular_components/app_layout/layout.scss.css',
    'pokemon_component.css',
  ],
  directives: [
    coreDirectives,
    MaterialListComponent,
    MaterialListItemComponent,
    MaterialSpinnerComponent,
  ],
)
class PokemonComponent implements OnInit, OnDestroy {
  final PokemonBloc _pokemonBloc = PokemonBloc(PokemonRepo());

  List<Pokemon> listPokemon;
  bool isLoading = false;
  StreamSubscription<List<Pokemon>> _pokemonListener;

  PokemonComponent() {
    _pokemonListener = _pokemonBloc.listPokemon.listen((listPokemon) {});
    _pokemonListener.onData((listPokemon) {
      this.listPokemon = listPokemon;
      this.isLoading = false;
    });
  }

  @override
  void ngOnInit() {
    isLoading = true;
    _pokemonBloc.retrievePokemon();
  }

  @override
  void ngOnDestroy() {
    _pokemonBloc.dispose();
  }

}