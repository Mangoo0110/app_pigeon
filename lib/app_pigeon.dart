/// You can use appPigeon for:
///   - saving auth
///   - listening to auth-state changes
///   - making authorized API calls
///   - initializing sockets

library;

export 'src/interface/app_pigeon.dart';
export 'src/authorized_pigeon.dart';
export 'src/ghost_pigeon.dart';
export 'src/params/socket_connect_param.dart';
export 'src/refresh_token_manager.dart';
export 'package:dio/dio.dart';
export 'package:flutter_secure_storage/flutter_secure_storage.dart';
