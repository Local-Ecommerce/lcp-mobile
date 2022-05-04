import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lcp_mobile/feature/apartment/model/apartment.dart';
import 'package:lcp_mobile/feature/apartment/repository/api_apartment_repository.dart';
import 'package:lcp_mobile/feature/feedback/model/feedback.dart';
import 'package:lcp_mobile/feature/feedback/repository/api_feedback_repository.dart';
import 'package:meta/meta.dart';
import 'package:lcp_mobile/feature/auth/helper/validators_transformer.dart';
import 'package:lcp_mobile/feature/auth/login/repository/repository.dart';
import 'package:lcp_mobile/feature/auth/model/user_app.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginRepository _loginRepository;
  ApiFeedBackRepository _apiFeedBackRepository;
  StreamSubscription _streamSubscription;
  ApiApartmentRepository _apiApartmentRepository;

  LoginBloc()
      : _loginRepository = FirebaseLoginRepository(),
        _apiFeedBackRepository = new ApiFeedBackRepository(),
        super(LoginState());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is EmailLoginChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordLoginChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is FeedBackChanged) {
      yield* _mapFeedBackChangedToState(event.feedback);
    } else if (event is ProductIdChanged) {
      yield* _mapProductIdChangedToState(event.productId);
    } else if (event is ImageFeedBackChanged) {
      yield* _mapImageChangedToState(event.images);
    } else if (event is FeedBackSubmitted) {
      yield* _mapSubmittedFeedBackToState();
    } else if (event is FeedBackUpdateEvent) {
      yield* _mapUpdateFeedBackToState(event);
    } else if (event is Submitted) {
      yield* _mapSubmittedLoginToState();
    } else if (event is GoogleLogin) {
      yield* _mapGoogleLoginToState();
    } else if (event is ResetPassSubmitted) {
      yield* _mapSubmittedResetPassToState();
    }
  }

  Stream<LoginState> _mapSubmittedFeedBackToState() async* {
    if (state.isFeedBackInvalid == false) {
      FeedbackRequest feedbackRequest = FeedbackRequest(
          feedbackDetail: state.feedBack,
          productId: state.productId,
          image: state.images);

      _streamSubscription = Stream.fromFuture(
              _apiFeedBackRepository.createFeedback(feedbackRequest))
          .listen((event) {
        add(FeedBackUpdateEvent(event));
      });
    }
  }

  Stream<LoginState> _mapUpdateFeedBackToState(
      FeedBackUpdateEvent event) async* {
    if (event.isSuccess) {
      yield FeedBackFinishedState(isSuccess: true);
    } else {
      yield FeedBackFinishedState(isSuccess: false);
    }
  }

  Stream<LoginState> _mapEmailChangedToState(String email) async* {
    yield state.copyWith(
        email: email,
        isEmailInvalid: !ValidatorsTransformer.isValidEmail(email));
  }

  Stream<LoginState> _mapFeedBackChangedToState(String feedBack) async* {
    yield state.copyWith(
        feedBack: feedBack,
        isFeedBackInvalid: !ValidatorsTransformer.isNonNullString(feedBack));
  }

  Stream<LoginState> _mapProductIdChangedToState(String productId) async* {
    yield state.copyWith(productId: productId);
  }

  Stream<LoginState> _mapImageChangedToState(List<String> images) async* {
    yield state.copyWith(images: images);
  }

  Stream<LoginState> _mapPasswordChangedToState(String password) async* {
    yield state.copyWith(
        password: password,
        isPasswordInvalid: !ValidatorsTransformer.isValidPassword(password));
  }

  Stream<LoginState> _mapSubmittedResetPassToState() async* {
    if (state.isEmailInvalid == false) {
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

  Stream<LoginState> _mapLoadCategoryEvent(LoadingApartmentEvent event) async* {
    _streamSubscription =
        Stream.fromFuture(_apiApartmentRepository.getAllApartments())
            .listen((apartments) {
      add(ApartmentUpdatedEvent(apartments: apartments));
    });
  }
}
