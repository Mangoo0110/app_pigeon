
part of '../../app_pigeon.dart';


class _AuthStatusDecider {
  static AuthStatus get(Auth? auth) {
    if(auth == null) {
      return UnAuthenticated();
    } 
    return Authenticated(auth: auth);
  }
}


class AuthService {
  final FlutterSecureStorage _secureStorage;
  final RefreshTokenManagerInterface refreshTokenManager;
  final Debugger _debugger = AuthServiceDebugger();
  late final AuthStorage _authStorage;
  AuthService(this._secureStorage, this.refreshTokenManager){
    _authStorage = AuthStorage(secureStorage: _secureStorage);
  }

  void init() {
    _debugger.dekhao("Initializing auth service...");
    _authStorage.init();
  }

  Stream<AuthStatus> get authStream => _authStorage._authStreamController.stream;

  Future<void> dispose() async{
    _authStorage.dispose();
  }

  

  /// Saves the new auth as currentAuth.
  /// Throws Exception, if user is still logged in.
  Future<void> saveNewAuth({required SaveNewAuthParams saveNewAuthParams}) async => _authStorage.saveNewAuth( saveNewAuthParams);

  Future<void> updateCurrentAuth({required UpdateAuthParams updateAuthParams}) async => _authStorage.updateCurrentAuth(updateAuthParams);

  Future<void> clearCurrentAuthRecord() async => await _authStorage.clearCurrentAuthRecord();

}
