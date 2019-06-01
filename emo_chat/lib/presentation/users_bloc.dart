import 'package:rxdart/rxdart.dart';

class UsersGroup {
  final BehaviorSubject<SignInState> _stateSubject = BehaviorSubject(seedValue: InitialView());
  final PublishSubject<SignInEvent> _eventSubject = PublishSubject();
  final PublishSubject<AppRoute> _navigationSubject = PublishSubject();

  Function(SignInEvent) get dispatch => _eventSubject.sink.add;

  Observable<SignInState> get state => _stateSubject.stream;

  Observable<AppRoute> get navigation => _navigationSubject.stream;

  SignInBloc() {
    _eventSubject.stream.listen((event) => _mapEventToState(_stateSubject.value, event));
  }

  _mapEventToState(SignInState lastState, SignInEvent event) {
    if (event is SignIn) {
      _navigationSubject.add(AppRoute(Routes.DASHBOARD));
    }
  }

  void dispose() {
    _stateSubject.close();
    _eventSubject.close();
    _navigationSubject.close();
  }


}