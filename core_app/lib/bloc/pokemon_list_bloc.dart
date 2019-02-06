import 'package:core_app/bloc/base_bloc.dart';
import 'package:core_app/repo/pokemon.dart';
import 'package:core_app/repo/pokemon_repo.dart';
import 'package:rxdart/rxdart.dart';

class PokemonListBloc extends BaseBloc {

  PokemonRepo _pokemonRepo;

  PokemonListBloc(this._pokemonRepo) {
    _retrievePokemon();
  }

  final BehaviorSubject<List<Pokemon>> _listPokemonCtrl = BehaviorSubject<List<Pokemon>>();

  Stream<List<Pokemon>> get listPokemon => _listPokemonCtrl.stream;
  Sink<List<Pokemon>> get pokemon => _listPokemonCtrl.sink;

  void _retrievePokemon() {
    showLoading(true);
    _pokemonRepo.getAll()
      .then((listPokemon) {
        pokemon.add(listPokemon);
        showLoading(false);
      }, onError: (err) {
        setErrorMessage(err.toString());
        showLoading(false);
      });
  }

  void dispose() {
    _listPokemonCtrl.close();
  }
}
