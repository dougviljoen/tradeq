import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:trademe_repository/trademe_repository.dart';

part '_login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository)
      : assert(_authRepository != null),
        super(const LoginState());

  final TrademeAuthRepository _authRepository;

  Future<String> get authorizationUrl async {
    return _authRepository.authorizationUrl;
  }

  Future<void> logInWithTrademe(String verifier) async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authRepository.logIn(verifier: verifier);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on Exception {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    } on NoSuchMethodError {
      emit(state.copyWith(status: FormzStatus.pure));
    }
  }
}
