import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/api_client.dart';
import 'core/storage/token_storage.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/auth/presentation/login_cubit.dart';
import 'features/items/data/item_repository.dart';
import 'features/items/presentation/item_list_cubit.dart';

final getIt = GetIt.instance;

class AppConfig {
  const AppConfig._();

  static const String baseUrl = 'https://interview-test.digital.cz/api';

  /// Collection resource used for the salary list and detail endpoints.
  static const String salariesResource = 'salaries';

  static const String testEmail = 'test@digital.cz';
  static const String testPassword = 'Heslo12345';
}

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();

  getIt.registerSingleton<TokenStorage>(TokenStorage(prefs));
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiClient>(), getIt<TokenStorage>()),
  );
  getIt.registerLazySingleton<ItemRepository>(
    () => ItemRepository(getIt<ApiClient>()),
  );

  getIt.registerFactory<LoginCubit>(() => LoginCubit(getIt<AuthRepository>()));
  getIt.registerFactory<ItemListCubit>(
    () => ItemListCubit(getIt<ItemRepository>(), getIt<AuthRepository>()),
  );
}
