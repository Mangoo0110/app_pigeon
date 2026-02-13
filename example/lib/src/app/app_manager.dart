
import 'package:app_pigeon/app_pigeon.dart';
import 'package:example/src/module/auth/repo/auth_repository.dart';
import 'package:flutter/cupertino.dart';

import '../core/di/service_locator.dart';
import '../module/auth/model/authenticated_user.dart';
import 'routing/app_router.dart';
import 'routing/route_names.dart';

class AppManager {
  static final AppManager _instance = AppManager._internal();
  /// Singleton
  factory AppManager() => _instance;
  AppManager._internal();

  bool _isAdmin = false;
  bool get isAdmin => _isAdmin;
  bool _thirdPartyLogin = false;

  ValueNotifier<AuthenticatedUser?> currentAuth = ValueNotifier(null);
  AuthorizedAppPigeon get authorizedPigeonClient => authorizedPigeon;
  GhostAppPigeon get ghostPigeonClient => ghostPigeon;
  ActivePigeonResolver get _activePigeonResolver =>
      serviceLocator<ActivePigeonResolver>();

  void initialize() async{
    //  currentAuth.value = await serviceLocator<AuthRepo>().currentUser();
    //  _onAuthChange(currentAuth.value);
    // Initialization code here
    serviceLocator<AuthRepository>().authStream.listen(
      _onAuthChange,
      onError: (e)=> {
        debugPrint(e.toString()),
      }
    );
  }

  void _onAuthChange(AuthenticatedUser? newAuth) async {
    debugPrint('Auth state changed::: $newAuth');
    if (newAuth != null) {
      // Stop ghost socket listeners/connection once user enters authorized mode.
      ghostPigeonClient.disconnectSocket();
      _activePigeonResolver.useAuthorized();
      // Authenticated user
      currentAuth.value = newAuth;
      AppRouter.navigateToReplacement(RouteNames.app, newAuth);
      _initializeGlobalDataProviders();
    } else {
      // Ensure authorized socket is not kept alive after logout.
      authorizedPigeonClient.disconnectSocket();
      _activePigeonResolver.useGhost();
      // Set current auth to null
      currentAuth.value = null;
      AppRouter.navigateToReplacement(RouteNames.login);
    }
  }

  void _initializeGlobalDataProviders() {

  }
}
