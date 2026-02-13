import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/core/constants/api_endpoints.dart';
import 'package:get_it/get_it.dart';

import '../../module/auth/repo/auth_repo_impl.dart';
import '../../module/auth/repo/auth_repository.dart';
import '../../module/auth/repo/refresh_token_manager_stub.dart';
import '../../module/chat/repo/chat_repo_impl.dart';
import '../../module/chat/repo/chat_repository.dart';
import '../../module/profile/repo/profile_repo_impl.dart';
import '../../module/profile/repo/profile_repository.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async{
  final AuthorizedAppPigeon authorizedPigeon = AuthorizedAppPigeon(
    MyRefreshTokenManager(),
    baseUrl: ApiEndpoints.baseUrl,
  );

  final GhostAppPigeon ghostPigeon = GhostAppPigeon(
    baseUrl: ApiEndpoints.baseUrl
  );

  serviceLocator.registerSingleton<AppPigeon>(authorizedPigeon);
  serviceLocator.registerSingleton<GhostAppPigeon>(ghostPigeon);
  serviceLocator.registerSingleton<AuthRepository>(AuthRepoImpl(authorizedPigeon));
  serviceLocator.registerSingleton<ChatRepository>(ChatRepoImpl(authorizedPigeon));
  serviceLocator.registerSingleton<ProfileRepository>(ProfileRepoImpl(authorizedPigeon));

}
