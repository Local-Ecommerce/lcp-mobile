part of 'register_bloc.dart';

abstract class RegisterEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class EmailChanged extends RegisterEvent {
  final String email;

  EmailChanged({@required this.email});

  @override
  String toString() => 'EmailChanged { email :$email }';

  @override
  List<Object> get props => [email];
}

class ConfirmNewPasswordChanged extends RegisterEvent {
  final String confirm;

  ConfirmNewPasswordChanged({@required this.confirm});

  @override
  String toString() => 'ConfirmNewPasswordChanged { confirm :$confirm }';

  @override
  List<Object> get props => [confirm];
}

class NewPasswordChanged extends RegisterEvent {
  final String newPassword;

  NewPasswordChanged({@required this.newPassword});

  @override
  String toString() => 'NewPasswordChanged { newPassword :$newPassword }';

  @override
  List<Object> get props => [newPassword];
}

class ImageChanged extends RegisterEvent {
  final String profileImage;

  ImageChanged({@required this.profileImage});

  @override
  String toString() => 'ImageChanged { profileImage :$profileImage }';

  @override
  List<Object> get props => [profileImage];
}

class ConFirmPasswordRegisterChanged extends RegisterEvent {
  final String confirmPassword;

  ConFirmPasswordRegisterChanged({@required this.confirmPassword});

  @override
  String toString() =>
      'ConFirmPasswordRegisterChanged { confirmPassword :$confirmPassword }';

  @override
  List<Object> get props => [confirmPassword];
}

class DeliveryAddressChanged extends RegisterEvent {
  final String deliveryAddress;

  DeliveryAddressChanged({@required this.deliveryAddress});

  @override
  String toString() => 'DeliveryAddressChanged { email :$deliveryAddress }';

  @override
  List<Object> get props => [deliveryAddress];
}

class ApartmentChanged extends RegisterEvent {
  final String apartment;

  ApartmentChanged({@required this.apartment});

  @override
  String toString() => 'ApartmentChanged { apartment :$apartment }';

  @override
  List<Object> get props => [apartment];
}

class PasswordChanged extends RegisterEvent {
  final String password;

  PasswordChanged({@required this.password});

  @override
  String toString() => 'PasswordChanged { password :$password }';

  @override
  List<Object> get props => [password];
}

class DobChanged extends RegisterEvent {
  final String dob;

  DobChanged({@required this.dob});

  @override
  String toString() => 'DobChanged { dob :$dob }';

  @override
  List<Object> get props => [dob];
}

class FullnameChanged extends RegisterEvent {
  final String fullname;

  FullnameChanged({@required this.fullname});

  @override
  String toString() => 'FullnameChanged { fullname :$fullname }';

  @override
  List<Object> get props => [fullname];
}

class GenderChanged extends RegisterEvent {
  final String gender;

  GenderChanged({@required this.gender});

  @override
  String toString() => 'GenderChanged { dob :$gender }';

  @override
  List<Object> get props => [gender];
}

class PhoneNumberChanged extends RegisterEvent {
  final String phonenum;

  PhoneNumberChanged({@required this.phonenum});

  @override
  String toString() => 'PhoneNumberChanged { dob :$phonenum }';

  @override
  List<Object> get props => [phonenum];
}

class LoadingApartmentEvent extends RegisterEvent {
  final List<Apartment> apartments;

  LoadingApartmentEvent({this.apartments});
}

class Submitted extends RegisterEvent {
  Submitted();
}

class ChangePassSubmitted extends RegisterEvent {
  ChangePassSubmitted();
}

class UpdateSubmitted extends RegisterEvent {
  UpdateSubmitted();
}

class UpdateGoogleSubmitted extends RegisterEvent {
  UpdateGoogleSubmitted();
}

class GoogleLogin extends RegisterEvent {
  GoogleLogin();
}
