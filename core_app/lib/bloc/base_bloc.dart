import 'package:rxdart/rxdart.dart';

class BaseBloc {

  final BehaviorSubject<bool> _isLoadingCtrl = BehaviorSubject<bool>(seedValue: false);
  final BehaviorSubject<String> _errorMessageCtrl = BehaviorSubject<String>(seedValue: "");

  Stream<bool> get isLoading => _isLoadingCtrl.stream;
  Function(bool) get showLoading => _isLoadingCtrl.sink.add;

  Stream<String> get errorMessage => _errorMessageCtrl.stream;
  Function(String) get setErrorMessage => _errorMessageCtrl.sink.add;

  void dispose() {
    _isLoadingCtrl.close();
    _errorMessageCtrl.close();
  }
}
