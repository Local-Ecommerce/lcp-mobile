import 'package:flutter/cupertino.dart';
import 'package:lcp_mobile/feature/auth/helper/validators_transformer.dart';
import 'package:lcp_mobile/feature/auth/login/repository/api_update_user_repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/firebase_login_repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/repository.dart';
import 'package:lcp_mobile/feature/auth/login/repository/update_user_repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';
import 'package:rxdart/rxdart.dart';

class RegisterBloc with ValidatorsTransformer {
  LoginRepository loginRepository;
  UpdateRepository updateRepository;

  RegisterBloc() {
    loginRepository = FirebaseLoginRepository();
    updateRepository = ApiUpdateUserRepository();
  }

  final BehaviorSubject<String> _fullNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _dobController = BehaviorSubject<String>();
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _genderController = BehaviorSubject<String>();
  final BehaviorSubject<String> _phoneNumberController =
      BehaviorSubject<String>();
  final BehaviorSubject<String> _comboboxController = BehaviorSubject<String>();

  Function(String) get onFullNameChanged => _fullNameController.sink.add;

  Function(String) get onDobChanged => _dobController.sink.add;

  Function(String) get onEmailChanged => _emailController.sink.add;

  Function(String) get onGenderChanged => _genderController.sink.add;

  Function(String) get onPasswordChanged => _passwordController.sink.add;

  Function(String) get onComboboxChanged => _comboboxController.sink.add;

  Function(String) get onPhoneNumberChanged => _phoneNumberController.sink.add;

  Stream<String> get fullName => _fullNameController.stream;

  Stream<bool> get fullName$ =>
      _fullNameController.stream.transform(validateRequireField);

  Stream<bool> get gender$ =>
      _genderController.stream.transform(validateRequireField);

  Stream<bool> get dob$ =>
      _dobController.stream.transform(validateRequireField);

  Stream<bool> get dobValue$ =>
      _dobController.stream.transform(validatePhoneNum);

  Stream<bool> get phoneNumber$ =>
      _phoneNumberController.stream.transform(validateRequireField);

  Stream<bool> get email$ => _emailController.stream.transform(validateEmail);

  Stream<bool> get password$ =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get validateResult$ => Rx.combineLatest<bool, bool>(
          [fullName$, email$, password$, gender$, dob$, phoneNumber$],
          (values) {
        print('hasNoErrors $values');
        bool hasNoErrors =
            (values.firstWhere((b) => b == false, orElse: () => null) == null);
        print('hasNoErrors $hasNoErrors');
        return hasNoErrors;
      });

  Stream<String> get combobox$ => _comboboxController.stream;

  Future<bool> register() async {
    UserData userData = UserData()
      ..fullName = _fullNameController.value
      ..dob = _dobController.value
      ..email = _emailController.value
      ..password = _passwordController.value
      ..apartmentId = _comboboxController.value
      ..phoneNumber = _phoneNumberController.value
      ..gender = _genderController.value
      ..role = "Customer";
    return loginRepository.register(userData);
  }

  Future<bool> updateProfile() async {
    UserData userData = UserData()
      ..fullName = _fullNameController.value
      ..dob = _dobController.value
      ..apartmentId = _comboboxController.value
      ..phoneNumber = _phoneNumberController.value
      ..gender = _genderController.value
      ..role = "Customer";
    return loginRepository.updateProfile(userData);
  }

  Future<bool> updateUser() async {
    UserData userData = UserData()
      ..fullName = _fullNameController.value
      ..dob = _dobController.value
      ..apartmentId = _comboboxController.value
      ..phoneNumber = _phoneNumberController.value
      ..gender = _genderController.value
      ..role = "Customer";
    return updateRepository.updateUser(userData);
  }

  updateStreamData(UserData userData) {
    _fullNameController.value = userData.fullName;
  }

  void changeDob(String date) {
    _dobController.sink.add(date);
  }

  get dobValue => _dobController.value;

  void dispose() {
    _fullNameController.close();
    _genderController.close();
    _dobController.close();
    _emailController.close();
    _passwordController.close();
    _comboboxController.close();
    _phoneNumberController.close();
  }
}
