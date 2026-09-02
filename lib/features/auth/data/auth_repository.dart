import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/storage/token_storage.dart';

enum SessionEvent { authenticated, loggedOut }

class AuthRepository {
  AuthRepository(this._apiClient, this._tokenStorage);

  final ApiClient _apiClient;
  final TokenStorage _tokenStorage;
  final StreamController<SessionEvent> _sessionController =
      StreamController<SessionEvent>.broadcast();

  Stream<SessionEvent> get sessionStream => _sessionController.stream;

  bool get isLoggedIn => _tokenStorage.hasToken;

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post<Map<String, dynamic>>(
        '/auth-token',
        data: {'email': email, 'password': password},
      );
      final data = response.data!;
      print('Auth response: $data');
      await _tokenStorage.save(
        data['token'] as String,
        data['expiresAt'] as int,
      );
      _sessionController.add(SessionEvent.authenticated);
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const ApiException('Invalid credentials.', statusCode: 401);
      }
      throw ApiException(
        'Could not sign in, please try again.',
        statusCode: error.response?.statusCode,
      );
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clear();
    _sessionController.add(SessionEvent.loggedOut);
  }

  void dispose() {
    _sessionController.close();
  }
}
