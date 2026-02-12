import 'package:app_pigeon/app_pigeon.dart';

extension AuthExt on Authenticated {
  bool get isVerified {
    return auth.data["isVerified"] == true || auth.data['is_verified'] == true;
  }

  String get userId {
    return auth.data['uid'] ?? auth.data['user_id'] ?? auth.data['userId'] ?? auth.data['id'];
  }

  String get userName {
    return auth.data['userName'] ?? auth.data['user_name'];
  }
}