import 'package:app_pigeon/app_pigeon.dart';
import 'package:get_it/get_it.dart';

import '../../module/auth/repo/auth_repo_impl.dart';
import '../../module/auth/repo/auth_repository.dart';
import '../../module/auth/repo/refresh_token_manager_stub.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  if (serviceLocator.isRegistered<AuthRepository>()) {
    return;
  }

  final appPigeon = AppPigeon(
    RefreshTokenManagerStub(),
    baseUrl: '',
  );

  serviceLocator.registerSingleton<AppPigeon>(appPigeon);
  serviceLocator.registerSingleton<AuthRepository>(AuthRepoImpl(appPigeon));

}
