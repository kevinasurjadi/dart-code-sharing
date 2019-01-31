import 'package:pokemon_dart/repo/model.dart';
import 'package:pokemon_dart/repo/repo.dart';
import 'package:rxdart/rxdart.dart';

class PokemonBloc {

  final PokemonRepo _pokemonRepo;

  PokemonBloc(this._pokemonRepo);

  final BehaviorSubject<List<Pokemon>> _listPokemonCtrl = BehaviorSubject<List<Pokemon>>();

  Stream<List<Pokemon>> get listPokemon => _listPokemonCtrl.stream.asBroadcastStream();

  void retrievePokemon() async {
    try {
      List<Pokemon> results = await _pokemonRepo.getAll();
      _listPokemonCtrl.add(results);
    } catch (e) {
      assert(e);
    }
  }

  void dispose() {
    _listPokemonCtrl.close();
  }
}
