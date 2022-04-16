part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EmailChanged extends LoginEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  List<Object> get props => [email];
}

class PasswordChanged extends LoginEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  String toString() => 'EmailChanged { email :$password }';

  @override
  List<Object> get props => [password];
}

class Submitted extends LoginEvent {
  Submitted();
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
