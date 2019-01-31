import 'package:flutter/material.dart';
import 'package:pokemon_dart/bloc.dart';
import 'package:pokemon_dart/repo/model.dart';
import 'package:pokemon_dart/repo/repo.dart';

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
  final PokemonBloc _pokemonBloc = PokemonBloc(PokemonRepo());

  HomePage() {
    _pokemonBloc.retrievePokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pokemon"),
      ),
      body: StreamBuilder<List<Pokemon>>(
          stream: _pokemonBloc.listPokemon,
          builder:
              (BuildContext context, AsyncSnapshot<List<Pokemon>> snapshot) {
            if (snapshot.hasData) {
              return Container(
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) => Card(
                        child: ListTile(
                          title: Text(
                            snapshot.data[index].name,),
                          subtitle: Text(snapshot.data[index].url),
                        ),
                      ),
                ),
              );
            } else {
              if (!snapshot.hasError) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    return Container();
                }
              } else {
                return Container();
              }
            }
          }),
    );
  }
}
