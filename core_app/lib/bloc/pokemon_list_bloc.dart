import 'package:core_app/bloc/base_bloc.dart';
import 'package:core_app/repo/pokemon.dart';
import 'package:core_app/repo/pokemon_repo.dart';
import 'package:rxdart/rxdart.dart';

class PokemonListBloc extends BaseBloc {
  PokemonRepo _pokemonRepo;

  PokemonListBloc(this._pokemonRepo) {
    retrievePokemon();
  }

  final BehaviorSubject<List<Pokemon>> _listPokemonCtrl =
      BehaviorSubject<List<Pokemon>>();

  Stream<List<Pokemon>> get listPokemon => _listPokemonCtrl.stream;
  Sink<List<Pokemon>> get pokemon => _listPokemonCtrl.sink;

  Future<void> retrievePokemon() async {
    showLoading(true);
    var listPokemon = await _pokemonRepo.getAll();
    pokemon.add(listPokemon);
    showLoading(false);
    return;
  }

  @override
  void dispose() {
    _listPokemonCtrl.close();
    super.dispose();
  }
}
