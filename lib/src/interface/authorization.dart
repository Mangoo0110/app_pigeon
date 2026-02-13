import '../../app_pigeon.dart';

abstract class Authorization {
  Stream<AuthStatus> get authStream;

  Future<void> saveNewAuth({required SaveNewAuthParams saveAuthParams});

  Future<void> updateCurrentAuth({
    required UpdateAuthParams updateAuthParams,
  });

  /// Returns the current auth record stored.
  Future<Auth?> getCurrentAuthRecord();

  /// Returns all saved separate auth records that are stored locally.
  Future<List<Auth>> getAllAuthRecords();

  /// This will remove the current auth reference and data stored locally.
  Future<void> logOut();

  /// Switches current auth by uid.
  Future<void> switchAccount({required String uid});
}
