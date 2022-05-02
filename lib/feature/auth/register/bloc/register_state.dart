part of 'register_bloc.dart';

class RegisterState extends Equatable {
  final bool isEmailInvalid;
  final bool isPasswordInvalid;
  final bool isNewPasswordInvalid;
  final bool isFullNameInvalid;
  final bool isGenderInvalid;
  final bool isDobInvalid;
  final bool isPhoneNumberInvalid;
  final bool isDeliveryAddressInvalid;
  final bool isApartmentInvalid;
  final bool isConfirmPasswordInvalid;
  final String newPassword;
  final String confirmPassword;
  final String profileImage;
  final String apartmentId;
  final String deliveryAddress;
  final String gender;
  final String fullname;
  final String dob;
  final String phonenum;
  final String email;
  final String password;

  bool get isFormValid =>
      isEmailInvalid && isPasswordInvalid && isGenderInvalid &&
      isFullNameInvalid && isDobInvalid && isPhoneNumberInvalid &&
      isDeliveryAddressInvalid && isApartmentInvalid && isConfirmPasswordInvalid;

  RegisterState(
      {this.isEmailInvalid,
      this.isPasswordInvalid,
      this.isNewPasswordInvalid,
      this.isDobInvalid,
      this.isFullNameInvalid,
      this.isGenderInvalid,
      this.isPhoneNumberInvalid,
      this.isDeliveryAddressInvalid,
      this.isApartmentInvalid,
      this.isConfirmPasswordInvalid,
      this.newPassword,
      this.confirmPassword,
      this.apartmentId,
      this.deliveryAddress,
      this.dob,
      this.fullname,
      this.gender,
      this.email,
      this.password,
      this.phonenum,
      this.profileImage,
      });

  RegisterState copyWith(
    {bool isEmailInvalid,
      bool isPasswordInvalid,
      bool isNewPasswordInvalid,
      bool isFullNameInvalid,
      bool isGenderInvalid,
      bool isDobInvalid,
      bool isPhoneNumberInvalid,
      bool isDeliveryAddressInvalid,
      bool isApartmentInvalid,
      bool isConfirmPasswordInvalid,
      String confirmPassword,
      String newPassword,
      String apartmentId,
      String deliveryAddress,
      String gender,
      String dob,
      String fullname,
      String phonenum,
      String email,
      String profileImage,
      String password}) {
    return RegisterState(
      isEmailInvalid: isEmailInvalid ?? this.isEmailInvalid,
      isConfirmPasswordInvalid: isConfirmPasswordInvalid ?? this.isConfirmPasswordInvalid,
      isPasswordInvalid: isPasswordInvalid ?? this.isPasswordInvalid,
      isNewPasswordInvalid: isNewPasswordInvalid ?? this.isNewPasswordInvalid,
      isDobInvalid: isDobInvalid ?? this.isDobInvalid,
      isFullNameInvalid: isFullNameInvalid ?? this.isFullNameInvalid,
      isGenderInvalid: isGenderInvalid ?? this.isGenderInvalid,
      isPhoneNumberInvalid: isPhoneNumberInvalid ?? this.isPhoneNumberInvalid,
      isDeliveryAddressInvalid: isDeliveryAddressInvalid ?? this.isDeliveryAddressInvalid,
      isApartmentInvalid: isApartmentInvalid ?? this.isApartmentInvalid,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      apartmentId: apartmentId ?? this.apartmentId,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      email: email ?? this.email,
      password: password ?? this.password,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      profileImage: profileImage ?? this.profileImage,
      phonenum: phonenum ?? this.phonenum,
      fullname: fullname ?? this.fullname,
    );
  }

  @override
  List<Object> get props =>
      [isEmailInvalid, isPasswordInvalid, isDobInvalid, isGenderInvalid, isFullNameInvalid, isPhoneNumberInvalid, isNewPasswordInvalid, isDeliveryAddressInvalid, isApartmentInvalid, isConfirmPasswordInvalid, confirmPassword, apartmentId, deliveryAddress, email, password, gender, fullname, dob, phonenum, profileImage, newPassword];
}

class RegisLoadingState extends RegisterState {}

class RegisFinishedState extends RegisterState {
  final bool isSuccess;

  RegisFinishedState({this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ChangePasswordFinishedState extends RegisterState {
  final bool isSuccess;

  ChangePasswordFinishedState({this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class UpdateFinishedState extends RegisterState {
  final bool isSuccess;

  UpdateFinishedState({this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class LoadApartmentFinished extends RegisterState {
  final List<Apartment> apartments;

  LoadApartmentFinished(this.apartments);
}
