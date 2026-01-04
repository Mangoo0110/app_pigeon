abstract interface class CurrentAuthUidManagerInterface {
  Future<String?> read();
  Future<void> saveCurrentAuthRef(String uid);
  Future<void> deleteCurrentAuthRef();
}
