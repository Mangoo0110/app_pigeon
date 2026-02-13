import '../../authorized_app_pigeon.dart';

abstract interface class AuthStorageInterface {
  /* ───────── Lifecycle ───────── */

  Future<void> init();
  void dispose();

  /* ───────── Auth state ───────── */

  /// Stream of auth status updates
  Stream<AuthStatus> get authStream;

  /// Returns current auth status synchronously from storage
  Future<AuthStatus> currentAuthStatus();

  /* ───────── Auth data ───────── */

  /// Returns current auth (if any)
  Future<Auth?> getCurrentAuth();

  /// Returns all stored auth records
  Future<List<Auth>> getAllAuth();

  /// Saves a new auth and sets it as current
  Future<void> saveNewAuth(SaveNewAuthParams saveAuthParams);

  /// Updates current auth record
  Future<void> updateCurrentAuth(UpdateAuthParams updateAuthParams);

  /// Clears current auth and storage reference
  Future<void> clearCurrentAuthRecord();

  /// Switches current auth by uid
  Future<void> switchAccount({required String uid});
}