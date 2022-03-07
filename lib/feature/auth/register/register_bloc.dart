import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/auth/login/repository/firebase_login_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lcp_mobile/feature/auth/helper/validators_transformer.dart';
import 'package:lcp_mobile/feature/auth/login/repository/repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

class RegisterBloc with ValidatorsTransformer {
  LoginRepository loginRepository;

  RegisterBloc() {
    loginRepository = FirebaseLoginRepository();
  }

  final BehaviorSubject<String> _fullNameController = BehaviorSubject<String>();
  // final BehaviorSubject<String> _lastNameController = BehaviorSubject<String>();
  final BehaviorSubject<String> _dobController = BehaviorSubject<String>();
  final BehaviorSubject<String> _emailController = BehaviorSubject<String>();
  final BehaviorSubject<String> _passwordController = BehaviorSubject<String>();
  final BehaviorSubject<String> _comboboxController =
      BehaviorSubject<String>.seeded("lstApartment");

  Function(String) get onFullNameChanged => _fullNameController.sink.add;

  Function(String) get onDobChanged => _dobController.sink.add;

  Function(String) get onEmailChanged => _emailController.sink.add;

  Function(String) get onPasswordChanged => _passwordController.sink.add;

  Function(String) get onComboboxChanged => _comboboxController.sink.add;

  Stream<bool> get fullName$ =>
      _fullNameController.stream.transform(validateRequireField);

  Stream<bool> get dob$ =>
      _dobController.stream.transform(validateRequireField);

  Stream<String> get dobValue$ => _dobController.stream;

  Stream<bool> get email$ => _emailController.stream.transform(validateEmail);

  Stream<bool> get password$ =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get validateResult$ =>
      Rx.combineLatest<bool, bool>([fullName$, email$, password$], (values) {
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
      //TODO cannot get dob value
      ..dob = _dobController.value
      ..email = _emailController.value
      ..password = _passwordController.value;
    return loginRepository.register(userData);
  }

  void changeDob(String date) {
    _dobController.sink.add(date);
  }

  get dobValue => _dobController.value;

  void dispose() {
    _fullNameController.close();
    // _lastNameController.close();
    _dobController.close();
    _emailController.close();
    _passwordController.close();
  }
}
