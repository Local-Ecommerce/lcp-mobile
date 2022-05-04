part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool isEmailInvalid;
  final bool isPasswordInvalid;
  final bool isFeedBackInvalid;
  final String feedBack;
  final String productId;
  final List<String> images;
  final String email;
  final String password;

  bool get isFormValid => isEmailInvalid && isPasswordInvalid;

  LoginState({
    this.isFeedBackInvalid,
    this.images,
    this.productId,
    this.isEmailInvalid,
    this.isPasswordInvalid,
    this.feedBack,
    this.email,
    this.password,
  });

  LoginState copyWith(
      {bool isEmailInvalid,
      bool isPasswordInvalid,
      bool isFeedBackInvalid,
      String feedBack,
      String productId,
      List<String> images,
      String email,
      String password}) {
    return LoginState(
      isEmailInvalid: isEmailInvalid ?? this.isEmailInvalid,
      productId : productId ?? this.productId,
      images: images ?? this.images,
      isPasswordInvalid: isPasswordInvalid ?? this.isPasswordInvalid,
      isFeedBackInvalid : isFeedBackInvalid ?? this.isFeedBackInvalid,
      feedBack : feedBack ?? this.feedBack,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object> get props =>
      [isEmailInvalid, isPasswordInvalid, isFeedBackInvalid, email, password, feedBack, productId, images];
}

class LoginLoadingState extends LoginState {}

class LoginFinishedState extends LoginState {
  final bool isSuccess;

  LoginFinishedState({this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class UpdateInfoState extends LoginState {
  final bool isSuccess;
  UpdateInfoState({this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class FeedBackFinishedState extends LoginState {
  final bool isSuccess;
  FeedBackFinishedState({this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}

class ForgotFinishedState extends LoginState {
  final bool isSuccess;
  ForgotFinishedState({this.isSuccess});

  @override
  List<Object> get props => [isSuccess];
}
