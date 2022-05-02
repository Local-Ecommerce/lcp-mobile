import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/apartment/repository/api_apartment_repository.dart';
import 'package:meta/meta.dart';
import 'package:lcp_mobile/feature/auth/helper/validators_transformer.dart';
import 'package:lcp_mobile/feature/auth/login/repository/repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository _loginRepository;
  StreamSubscription _streamSubscription;
  ApiApartmentRepository _apiApartmentRepository;

  LoginBloc()
      : _loginRepository = FirebaseLoginRepository(),
        super(LoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailLoginChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordLoginChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapSubmittedLoginToState();
    } else if (event is GoogleLogin) {
      yield* _mapGoogleLoginToState();
    } else if (event is ResetPassSubmitted) {
      yield* _mapSubmittedResetPassToState();
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.copyWith(
        email: email,
        isEmailInvalid: !ValidatorsTransformer.isValidEmail(email));
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.copyWith(
        password: password,
        isPasswordInvalid: !ValidatorsTransformer.isValidPassword(password));
  }

  Stream<LoginState> _mapSubmittedResetPassToState() async* {
    if(state.isEmailInvalid == false){
      try {
        if (await _loginRepository.resetPassword(state.email)) {
          yield ForgotFinishedState(isSuccess: true);
        } else {
          yield ForgotFinishedState(isSuccess: false);
        }
      } on Exception catch (e) {
        print(e);
        yield ForgotFinishedState(isSuccess: false);
      }
    } else {
      yield ForgotFinishedState(isSuccess: false);
    }
  }

  Stream<LoginState> _mapSubmittedLoginToState() async* {
    if (state.isEmailInvalid == false && state.isPasswordInvalid == false) {
      try {
        if (await _loginRepository.signIn(state.email, state.password)) {
          yield LoginFinishedState(isSuccess: true);
        } else {
          yield LoginFinishedState(isSuccess: false);
        }
      } on Exception catch (e) {
        print(e);
        yield LoginFinishedState(isSuccess: false);
      }
    } else {
      yield LoginFinishedState(isSuccess: false);
    }
  }

  Stream<LoginState> _mapGoogleLoginToState() async* {
    try {
      if (await _loginRepository.googleLogin()) {
        yield LoginFinishedState(isSuccess: true);
      } else {
        yield UpdateInfoState(isSuccess: true);
      }
    } on Exception catch (e) {
      print(e);
      yield LoginFinishedState(isSuccess: false);
    }
  }

  Stream<LoginState> _mapLoadCategoryEvent(
      LoadingApartmentEvent event) async* {
    _streamSubscription =
        Stream.fromFuture(_apiApartmentRepository.getAllApartments())
            .listen((apartments) {
          add(ApartmentUpdatedEvent(apartments: apartments));
        });
  }
}
