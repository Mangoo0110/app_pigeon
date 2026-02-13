import 'package:example/src/core/api_handler/api_response.dart';

typedef AsyncRequest<T> = Future<ApiResponse<T>>;
