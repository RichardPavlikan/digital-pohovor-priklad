import 'package:dio/dio.dart';

import '../../injection.dart';
import '../storage/token_storage.dart';

/// Thin wrapper around [Dio] that keeps the bearer token in sync.
///
/// When a request comes back with 401 the interceptor fetches a fresh
/// token and replays the original request, so the rest of the app can
/// stay unaware of the token lifecycle.
class ApiClient {
  ApiClient(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenStorage.token;
          if (token != null && !_tokenStorage.isExpired) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            final token = await _reauthenticate();
            final request = error.requestOptions;
            request.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch<dynamic>(request);
            return handler.resolve(response);
          }
          handler.next(error);
        },
      ),
    );
  }

  late final Dio _dio;
  final TokenStorage _tokenStorage;

  Dio get dio => _dio;

  Future<String> _reauthenticate() async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth-token',
      data: {'email': AppConfig.testEmail, 'password': AppConfig.testPassword},
    );
    final data = response.data!;
    final token = data['token'] as String;
    await _tokenStorage.save(token, data['expiresAt'] as int);
    return token;
  }
}
