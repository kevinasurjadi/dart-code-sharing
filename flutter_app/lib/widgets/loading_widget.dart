import 'package:flutter/material.dart';
import 'package:core_app/core.dart';

class LoadingWidget extends StatelessWidget {

  final BaseBloc _baseBloc;

  LoadingWidget(this._baseBloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _baseBloc.isLoading,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
