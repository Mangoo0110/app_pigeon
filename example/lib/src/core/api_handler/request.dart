import 'package:example/src/core/api_handler/api_response.dart';

import 'api_handler.dart';

typedef Request<T> = ApiResponse<T>;

typedef FutureRequest<T> = Future<Request<T>>;