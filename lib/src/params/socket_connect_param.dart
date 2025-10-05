
class SocketConnetParamX {
  ///[Optional]
  ///
  /// Leave this field null, if you want to use your current auth's access token instead.
  final String? token;
  final String socketUrl;
  final String joinId;
  SocketConnetParamX({
    required this.token,
    required this.socketUrl,
    required this.joinId,
  });
}