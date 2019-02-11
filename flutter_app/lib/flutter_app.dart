import 'package:flutter/material.dart';
import 'package:core_app/core.dart';
import 'package:flutter_app/widgets/base_widget.dart';

class FlutterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final PokemonListBloc _pokemonListBloc = PokemonListBloc(PokemonRepo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon"),
      ),
      body: RefreshIndicator(
        child: BaseWidget(
          _pokemonListBloc as BaseBloc,
          body: StreamBuilder<List<Pokemon>>(
              stream: _pokemonListBloc.listPokemon,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Pokemon>> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) => Card(
                            child: ListTile(
                              title: Text(
                                snapshot.data[index].name,
                              ),
                              subtitle: Text(snapshot.data[index].url),
                            ),
                          ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
        onRefresh: _pokemonListBloc.retrievePokemon,
      ),
    );
  }
}
