import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:lcp_mobile/feature/apartment/repository/api_apartment_repository.dart';
import 'package:lcp_mobile/feature/auth/helper/validators_transformer.dart';
import 'package:lcp_mobile/feature/auth/login/repository/repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/update_user_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';

part 'register_state.dart';
part 'register_event.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  LoginRepository _loginRepository;
  UpdateRepository updateRepository;
  ApiApartmentRepository _apiApartmentRepository;

  RegisterBloc()
      : _loginRepository = FirebaseLoginRepository(),
        super(RegisterState());

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is NewPasswordChanged) {
      yield* _mapNewPasswordChangedToState(event.newPassword);
    } else if (event is ConFirmPasswordRegisterChanged) {
      yield* _mapConfirmPasswordChangedToState(event.confirmPassword);
    } else if (event is ConfirmNewPasswordChanged) {
      yield* _mapConfirmNewPasswordChangedToState(event.confirm);
    } else if (event is FullnameChanged) {
      yield* _mapFullNameChangedToState(event.fullname);
    } else if (event is ApartmentChanged) {
      yield* _mapApartmentChangedToState(event.apartment);
    } else if (event is DobChanged) {
      yield* _mapDobChangedToState(event.dob);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is ImageChanged) {
      yield* _mapImageChangeToState(event.profileImage);
    } else if (event is DeliveryAddressChanged) {
      yield* _mapDeliveryAddressToState(event.deliveryAddress);
    } else if (event is PhoneNumberChanged) {
      yield* _mapPhoneNumberChangedToState(event.phonenum);
    } else if (event is Submitted) {
      yield* _mapSubmittedRegisterToState();
    } else if (event is UpdateGoogleSubmitted) {
      yield* _mapSubmittedUpdateGoogleToState();
    } else if (event is LoadingApartmentEvent) {
      yield* _mapLoadApartmentEventToState(event);
    } else if (event is UpdateSubmitted) {
      yield* _mapSubmittedUpdateToState();
    } else if (event is ChangePassSubmitted) {
      yield* _mapSubmittedChangePassToState();
    }
  }

  Stream<RegisterState> _mapSubmittedUpdateGoogleToState() async* {
    if (checkStateUpdateGoogleValid()) {
      UserData userData = UserData()
        ..fullName = state.fullname
        ..apartmentId = state.apartmentId
        ..deliveryAddress = state.deliveryAddress
        ..phoneNumber = state.phonenum
        ..role = "Customer";
      if (await _loginRepository.updateProfile(userData)) {
        yield UpdateFinishedState(isSuccess: true);
      } else {
        yield UpdateFinishedState(isSuccess: false);
      }
    } else {
      yield UpdateFinishedState(isSuccess: false);
    }
  }

  Stream<RegisterState> _mapSubmittedUpdateToState() async* {
    if (checkStateUpdateValid()) {
      UserData userData = UserData()
        ..fullName = state.fullname
        ..profileImage = state.profileImage
        ..dob = state.dob
        ..apartmentId = state.apartmentId
        ..deliveryAddress = state.deliveryAddress
        ..phoneNumber = state.phonenum
        ..gender = state.gender
        ..role = "Customer";
      if (await _loginRepository.updateProfile(userData)) {
        yield UpdateFinishedState(isSuccess: true);
      } else {
        yield UpdateFinishedState(isSuccess: false);
      }
    } else {
      yield UpdateFinishedState(isSuccess: false);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield state.copyWith(
        email: email,
        isEmailInvalid: !ValidatorsTransformer.isValidEmail(email));
  }

  Stream<RegisterState> _mapImageChangeToState(String image) async* {
    yield state.copyWith(profileImage: image);
  }

  Stream<RegisterState> _mapFullNameChangedToState(String fullname) async* {
    yield state.copyWith(
        fullname: fullname,
        isFullNameInvalid: !ValidatorsTransformer.isNonNullString(fullname));
  }

  Stream<RegisterState> _mapDeliveryAddressToState(
      String deliveryAddress) async* {
    yield state.copyWith(
        deliveryAddress: deliveryAddress,
        isDeliveryAddressInvalid:
            !ValidatorsTransformer.isNonNullString(deliveryAddress));
  }

  Stream<RegisterState> _mapGenderChangedToState(String gender) async* {
    yield state.copyWith(
        gender: gender,
        isGenderInvalid: !ValidatorsTransformer.isNonNullString(gender));
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield state.copyWith(
        password: password,
        isPasswordInvalid: !ValidatorsTransformer.isValidPassword(password));
  }

  Stream<RegisterState> _mapNewPasswordChangedToState(
      String newPassword) async* {
    yield state.copyWith(
        newPassword: newPassword,
        isNewPasswordInvalid:
            !ValidatorsTransformer.isValidPassword(newPassword));
  }

  Stream<RegisterState> _mapConfirmPasswordChangedToState(
      String confirmPassword) async* {
    yield state.copyWith(
        confirmPassword: confirmPassword,
        isConfirmPasswordInvalid: !ValidatorsTransformer.isValidConfirmPassword(
            confirmPassword, state.password));
  }

  Stream<RegisterState> _mapConfirmNewPasswordChangedToState(
      String confirmPassword) async* {
    yield state.copyWith(
        confirmPassword: confirmPassword,
        isConfirmPasswordInvalid: !ValidatorsTransformer.isValidConfirmPassword(
            confirmPassword, state.newPassword));
  }

  Stream<RegisterState> _mapPhoneNumberChangedToState(
      String phoneNumber) async* {
    yield state.copyWith(
        phonenum: phoneNumber,
        isPhoneNumberInvalid: !ValidatorsTransformer.isValidPhone(phoneNumber));
  }

  Stream<RegisterState> _mapDobChangedToState(String dob) async* {
    yield state.copyWith(
        dob: dob, isDobInvalid: !ValidatorsTransformer.isValidDate(dob));
  }

  Stream<RegisterState> _mapApartmentChangedToState(String apartmentId) async* {
    yield state.copyWith(
        apartmentId: apartmentId,
        isApartmentInvalid:
            !ValidatorsTransformer.isNonNullString(apartmentId));
  }

  Stream<RegisterState> _mapSubmittedChangePassToState() async* {
    if (state.isPasswordInvalid == false &&
        state.isConfirmPasswordInvalid == false &&
        state.isNewPasswordInvalid == false) {
      try {
        if (await _loginRepository.changePassword(
            state.password, state.newPassword)) {
          yield ChangePasswordFinishedState(isSuccess: true);
        } else {
          yield ChangePasswordFinishedState(isSuccess: false);
        }
      } on Exception catch (e) {
        print(e);
        yield ChangePasswordFinishedState(isSuccess: false);
      }
    } else {
      yield ChangePasswordFinishedState(isSuccess: false);
    }
  }

  Stream<RegisterState> _mapSubmittedRegisterToState() async* {
    if (checkStateRegisterValid()) {
      UserData userData = UserData()
        ..fullName = state.fullname
        ..dob = state.dob
        ..email = state.email
        ..password = state.password
        ..apartmentId = state.apartmentId
        ..deliveryAddress = state.deliveryAddress
        ..phoneNumber = state.phonenum
        ..gender = state.gender
        ..role = "Customer";
      if (await _loginRepository.register(userData)) {
        yield RegisFinishedState(isSuccess: true);
      } else {
        yield RegisFinishedState(isSuccess: false);
      }
    } else {
      yield RegisFinishedState(isSuccess: false);
    }
  }

  Stream<RegisterState> _mapLoadApartmentEventToState(
      LoadingApartmentEvent event) async* {
    var apartment = await _apiApartmentRepository.getAllApartments();

    yield LoadApartmentFinished(apartment);
  }

  bool checkStateRegisterValid() {
    if (state.isEmailInvalid == false &&
        state.isPasswordInvalid == false &&
        state.isApartmentInvalid == false &&
        state.isDeliveryAddressInvalid == false &&
        state.isPhoneNumberInvalid == false &&
        state.isFullNameInvalid == false &&
        state.confirmPassword == state.password) {
      return true;
    }
    return false;
  }

  bool checkStateUpdateValid() {
    if (state.isDobInvalid == false &&
        state.isApartmentInvalid == false &&
        state.isDeliveryAddressInvalid == false &&
        state.isGenderInvalid == false &&
        state.isPhoneNumberInvalid == false &&
        state.isFullNameInvalid == false) {
      return true;
    }
    return false;
  }

  bool checkStateUpdateGoogleValid() {
    if (state.isApartmentInvalid == false &&
        state.isDeliveryAddressInvalid == false &&
        state.isPhoneNumberInvalid == false &&
        state.isFullNameInvalid == false) {
      return true;
    }
    return false;
  }
}
