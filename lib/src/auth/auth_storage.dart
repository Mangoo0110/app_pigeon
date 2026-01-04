part of '../../app_pigeon.dart';

class _AuthStatusDecider {
  static AuthStatus get(Auth? auth) {
    if(auth == null) {
      return UnAuthenticated();
    } 
    return Authenticated(auth: auth);
  }
}

base class AuthService implements AuthStorageInterface{
  AuthService(){
    _authStreamController.add(AuthLoading());
    _authManager = _AuthManger( _secureStorage, _authDebugger);
    _currentAuthUidManager = _CurrentAuthUidManger(_secureStorage);
  }
  
  late final _AuthManger _authManager;
  late final _CurrentAuthUidManger _currentAuthUidManager;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock
    ));
  final Debugger _authDebugger = AuthServiceDebugger();
  final StreamController<AuthStatus> _authStreamController = StreamController.broadcast();

  @override
  dispose() {
    _authStreamController.close();
    _secureStorage.unregisterAllListeners();
  }
  
  /// Initializes auth storage listening, updates auth stream on change in secure storage
  @override
  init() async{
    await getCurrentAuth().then((currentAuth) async{
      final AuthStatus authStatus = _AuthStatusDecider.get(currentAuth);
      _authStreamController.add(authStatus);
    });
    void onCurrentAuthChange(String? encodedAuth) async{
      _authDebugger.dekhao("Current auth changed in AuthStorage...");
      if(encodedAuth == null ) {
        _authStreamController.add(UnAuthenticated());
        return;
      }
        
        final auth = await getCurrentAuth();
        if(auth == null) {
          _authStreamController.add(UnAuthenticated());
          return;
        }
        _authStreamController.add(Authenticated(auth: auth));
      }
    _authDebugger.dekhao("Registering listeners in auth storage.");
    _secureStorage.registerListener(key: _currentAuthUidManager.currentAuthKey, listener: onCurrentAuthChange);
  }

  @override
  Future<AuthStatus> currentAuthStatus() async{
    return await getCurrentAuth().then((currentAuth) => _AuthStatusDecider.get(currentAuth));
  }

  @override
  Future<List<Auth>> getAllAuth() async => await _authManager.readAllAuth();

  @override
  Future<Auth?> getCurrentAuth() async{
    // First read uid of the current auth
    final uidOfCurrentAuth = await _currentAuthUidManager.read();
    if(uidOfCurrentAuth == null) {
      return null;
    }
    // Read the auth with the uid
    return await _authManager.read(uId: uidOfCurrentAuth);
  }

  /// Saves auth as current auth
  @override
  Future<void> saveNewAuth(SaveNewAuthParams saveAuthParams) async{
    final auth = Auth._internal(
          accessToken: saveAuthParams.accessToken,
          refreshToken: saveAuthParams.refreshToken,
          data: saveAuthParams.data,
        );
    // >> Save user auth
    // ** Its important to save the auth first before saving the uid as current auth ref,
    // because any change with current-auth-ref will trigger the storage listener that listens with current-auth-ref's key.
    // If the auth is saved first, then only listeners will get the saved auth instance.
    await _authManager.write(uId: saveAuthParams.uid, auth: auth);
    // Save as current auth. This will trigger the storage listener and will update the authstatus (as per the current implementation.)
    await _currentAuthUidManager.saveCurrentAuthRef(saveAuthParams.uid);
  }

  /// Updates current auth
  @override
  Future<void> updateCurrentAuth(UpdateAuthParams updateAuthParams) async{
    // Check if current auth exists and given current user key is same as current user key
    // saved in secure storage(source of truth)
    final currentAuth = await getCurrentAuth();
    final uidOfCurrentAuth = await _currentAuthUidManager.read();
    if(currentAuth == null || uidOfCurrentAuth == null) {
      throw Exception("Auth does not exist!");
    }
    // convert to auth object
    final auth = Auth._internal(
        accessToken: updateAuthParams.accessToken,
        refreshToken: updateAuthParams.refreshToken,
        data: updateAuthParams.data ?? currentAuth.data,
      );
    // Save the new auth instance.
    await _authManager.write(uId: uidOfCurrentAuth, auth: auth);
  }

  @override
  Future<void> clearCurrentAuthRecord() async {
    _authDebugger.dekhao("Clearing auth record");
    await _authManager.delete(uId: (await _currentAuthUidManager.read()) ?? "");
    // Delete/Remove current auth ref also
    _authDebugger.dekhao("Deleting current auth ref");
    await _currentAuthUidManager.deleteCurrentAuthRef();
  }
  
  @override
  Stream<AuthStatus> get authStream => _authStreamController.stream;
  
}

class _CurrentAuthUidManger implements CurrentAuthUidManagerInterface {
  final FlutterSecureStorage _secureStorage;
  _CurrentAuthUidManger(this._secureStorage);
  final String currentAuthKey = "current_auth";

  /// Returns uid of current auth
  @override
  Future<String?> read() async{
    return await _secureStorage.read(key: currentAuthKey);
  }

  /// Saves uid of current auth
  @override
  Future<void> saveCurrentAuthRef(String uid) async{
    return await _secureStorage.write(key: currentAuthKey, value: uid);
  }

  /// Delete current auth uid
  @override
  Future<void> deleteCurrentAuthRef() async{
    return await _secureStorage.delete(key: currentAuthKey);
  }
}

class _AuthManger {
  final FlutterSecureStorage _secureStorage;
  final Debugger _debugger;
  _AuthManger(this._secureStorage, this._debugger);
  // Auths with uid as key
  //final Map<String, Auth> _auths = {};
  //Map<String, Auth> get auths => Map<String, Auth>.from(_auths);

  /// "auth_$uid"
  static String userAuthKey({required String uid}){
    return "auth_$uid";
  }
  /// Saves the auth
  Future<void> write({required String uId, required Auth auth}) async{
    _debugger.dekhao("Writing auth with uid: ${userAuthKey(uid: uId)}, data : ${auth.toJson()}");
    await _secureStorage.write(key: userAuthKey(uid: uId), value: jsonEncode(auth.toJson()));
    //_auths[uId] = auth;
  }

  Future<Auth?> read({required String uId}) async{
    final jsonString = await _secureStorage.read(key: userAuthKey(uid: uId));
    if(jsonString == null) {
      return null;
    }
    return Auth._tryFromJsonString(jsonString);
  }

  Future<List<Auth>> readAllAuth() async {
    _debugger.dekhao("Getting auths");
    final response = await _secureStorage.readAll();
    List<Auth> auths = [];
    for(final encoded in response.entries) {
      if(encoded.key.startsWith("auth_")) {
        final auth = Auth._tryFromJsonString(encoded.value);
        if(auth != null) {
          //_auths[encoded.key] = auth;
          auths.add(auth);
        }
      }
    }
    return auths;
  }

  Future<void> delete({required String uId}) async{
    await _secureStorage.delete(key: userAuthKey(uid: uId));
    //_auths.remove(uId);
  }

  Future<void> deleteAll() async{
    await _secureStorage.deleteAll();
    //_auths.clear();
  }

}
