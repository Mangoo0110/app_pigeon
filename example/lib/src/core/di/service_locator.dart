import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/constants/api_endpoints.dart';
import 'package:get_it/get_it.dart';

import '../../module/auth/repo/auth_repo_impl.dart';
import '../../module/auth/repo/auth_repository.dart';
import '../../module/auth/repo/refresh_token_manager_stub.dart';
import '../../module/chat/repo/chat_repo_impl.dart';
import '../../module/chat/repo/chat_repository.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async{
  final appPigeon = AppPigeon(
    MyRefreshTokenManager(),
    baseUrl: ApiEndpoints.baseUrl,
  );
  serviceLocator.registerSingleton<AppPigeon>(appPigeon);
  serviceLocator.registerSingleton<AuthRepository>(AuthRepoImpl(appPigeon));
  serviceLocator.registerSingleton<ChatRepository>(ChatRepoImpl(appPigeon));

}
