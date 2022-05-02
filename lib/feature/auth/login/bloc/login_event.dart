part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EmailLoginChanged extends LoginEvent {
  final String email;

  EmailLoginChanged({@required this.email});

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  List<Object> get props => [email];
}

class PasswordLoginChanged extends LoginEvent {
  final String password;

  PasswordLoginChanged({@required this.password});

  @override
  String toString() => 'PasswordChanged { password :$password }';

  @override
  List<Object> get props => [password];
}

class Submitted extends LoginEvent {
  Submitted();
}

class ResetPassSubmitted extends LoginEvent {
  ResetPassSubmitted();
}

class GoogleLogin extends LoginEvent {
  GoogleLogin();
}

class LoadingApartmentEvent extends LoginEvent {
  final List<Apartment> apartments;

  LoadingApartmentEvent({this.apartments});

  @override
  List<Object> get props => [apartments];
}

class ApartmentUpdatedEvent extends LoginEvent {
  final List<Apartment> apartments;

  ApartmentUpdatedEvent({this.apartments});

  @override
  List<Object> get props => [apartments];
}

// class SignInCheck extends LoginEvent {
//   SignInCheck();
// }
