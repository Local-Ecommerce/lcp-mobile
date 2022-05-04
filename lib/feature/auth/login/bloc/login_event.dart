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

class FeedBackChanged extends LoginEvent {
  final String feedback;

  FeedBackChanged({@required this.feedback});

  @override
  String toString() => 'FeedBackChanged { feedback :$feedback }';

  @override
  List<Object> get props => [feedback];
}

class ProductIdChanged extends LoginEvent {
  final String productId;

  ProductIdChanged({@required this.productId});

  @override
  String toString() => 'ProductIdChanged { productId :$productId }';

  @override
  List<Object> get props => [productId];
}

class ImageFeedBackChanged extends LoginEvent {
  final List<String> images;

  ImageFeedBackChanged({@required this.images});

  @override
  String toString() => 'ImageChanged { images :$images }';

  @override
  List<Object> get props => [images];
}

class FeedBackUpdateEvent extends LoginEvent {
  final bool isSuccess;
  FeedBackUpdateEvent(this.isSuccess);
    @override
  List<Object> get props => [isSuccess];
}

class Submitted extends LoginEvent {
  Submitted();
}

class ResetPassSubmitted extends LoginEvent {
  ResetPassSubmitted();
}

class FeedBackSubmitted extends LoginEvent {
  FeedBackSubmitted();
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

