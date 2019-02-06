import 'package:core_app/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/loading_widget.dart';

class BaseWidget extends StatefulWidget {
  final BaseBloc baseBloc;
  final Widget body;

  BaseWidget(this.baseBloc, {@required this.body});

  @override
  _BaseWidgetState createState() => _BaseWidgetState();
}

class _BaseWidgetState extends State<BaseWidget> {
  void _showErrorDialog(BuildContext context, String errorText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorText),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    widget.baseBloc.errorMessage.listen((error) {
      if (error.isNotEmpty) {
        _showErrorDialog(context, error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.body,
        LoadingWidget(widget.baseBloc),
      ],
    );
  }

  @override
  void dispose() {
    widget.baseBloc.dispose();
    super.dispose();
  }

}
