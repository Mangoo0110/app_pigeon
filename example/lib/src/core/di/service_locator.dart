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
const String kAuthorizedPigeon = 'authorized_pigeon';
const String kGhostPigeon = 'ghost_pigeon';

AuthorizedPigeon get authorizedPigeon =>
    serviceLocator<AuthorizedPigeon>();
GhostPigeon get ghostPigeon =>
    serviceLocator<GhostPigeon>();
AppPigeon get authorizedClient =>
    serviceLocator<AppPigeon>(instanceName: kAuthorizedPigeon);
AppPigeon get ghostClient =>
    serviceLocator<AppPigeon>(instanceName: kGhostPigeon);

class ActivePigeonResolver {
  ActivePigeonResolver({
    required this.authorized,
    required this.ghost,
    AppPigeon? initial,
  }) : _current = initial ?? ghost;

  final AppPigeon authorized;
  final AppPigeon ghost;
  AppPigeon _current;

  AppPigeon get current => _current;
  bool get isGhost => identical(_current, ghost);
  bool get isAuthorized => identical(_current, authorized);

  void useAuthorized() => _current = authorized;
  void useGhost() => _current = ghost;
}

Future<void> setupServiceLocator() async{
  if (serviceLocator.isRegistered<AuthRepository>()) {
    return;
  }

  final authorized = AuthorizedPigeon(
    MyRefreshTokenManager(),
    baseUrl: ApiEndpoints.baseUrl,
  );
  final ghost = GhostPigeon(baseUrl: ApiEndpoints.baseUrl);

  serviceLocator.registerSingleton<AuthorizedPigeon>(authorized);
  serviceLocator.registerSingleton<GhostPigeon>(ghost);

  // Named interface registrations to support dual-mode use cases.
  serviceLocator.registerSingleton<AppPigeon>(
    authorized,
    instanceName: kAuthorizedPigeon,
  );
  serviceLocator.registerSingleton<AppPigeon>(
    ghost,
    instanceName: kGhostPigeon,
  );
  serviceLocator.registerSingleton<ActivePigeonResolver>(
    ActivePigeonResolver(
      authorized: authorized,
      ghost: ghost,
    ),
  );

  // Backward compatibility for existing modules currently assuming authorized client.
  serviceLocator.registerSingleton<AppPigeon>(authorized);
  serviceLocator.registerSingleton<AuthRepository>(AuthRepoImpl(authorized));
  serviceLocator.registerSingleton<ChatRepository>(
    ChatRepoImpl(() => serviceLocator<ActivePigeonResolver>().current),
  );
  serviceLocator.registerSingleton<ProfileRepository>(ProfileRepoImpl(authorized));

}
