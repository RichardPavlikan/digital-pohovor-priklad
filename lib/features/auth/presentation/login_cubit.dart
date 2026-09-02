import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_exception.dart';
import '../data/auth_repository.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState extends Equatable {
  const LoginState({this.status = LoginStatus.initial, this.error});

  final LoginStatus status;
  final String? error;

  bool get isLoading => status == LoginStatus.loading;

  LoginState copyWith({LoginStatus? status, String? error}) {
    return LoginState(status: status ?? this.status, error: error);
  }

  @override
  List<Object?> get props => [status, error];
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(const LoginState());

  final AuthRepository _authRepository;

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading));
    try {
      await _authRepository.login(email, password);
      emit(state.copyWith(status: LoginStatus.success));
    } on ApiException catch (error) {
      print('Login failed for $email / $password: ${error.message}');
      emit(state.copyWith(status: LoginStatus.failure, error: error.message));
    }
  }
}
