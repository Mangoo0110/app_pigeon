# app_pigeon

`app_pigeon` is a Flutter networking and socket layer with two operation modes:

1. `AuthorizedAppPigeon`: token-based HTTP + auth persistence + refresh flow.
2. `GhostAppPigeon`: lightweight HTTP + socket client for anonymous/guest/ghost use cases.

The package exposes a shared `AppPigeon` interface so app code can depend on a common contract while switching implementations at runtime.

## Capabilities

1. Typed HTTP wrappers over `dio`:
   - `get`, `post`, `put`, `patch`, `delete`
2. Realtime socket API:
   - `socketInit`, `listen`, `emit`
3. Authorized mode auth persistence:
   - secure local auth storage via `flutter_secure_storage`
   - multiple account records
   - current-account switching
   - auth stream updates
4. Authorized mode auto-refresh:
   - interceptor-driven refresh flow on unauthorized responses
   - refresh request queueing + replay of pending requests
5. Ghost mode optional bearer support:
   - ghost interceptor can attach bearer if you call `setAuthToken(...)`

## Install

Add to `pubspec.yaml`:

```yaml
dependencies:
  app_pigeon: ^<latest>
```

## Exports

`package:app_pigeon/app_pigeon.dart` exports:

1. `AppPigeon` (interface)
2. `AuthorizedAppPigeon`
3. `GhostAppPigeon`
4. `SocketConnetParamX`
5. `RefreshTokenManagerInterface`, `RefreshTokenResponse`
6. `dio` types
7. `flutter_secure_storage` types

## Core Types

### `AppPigeon` interface

The shared contract:

1. `Future<Response> get/post/put/patch/delete(...)`
2. `Future<void> socketInit(SocketConnetParamX param)`
3. `Stream<dynamic> listen(String channelName)`
4. `void emit(String eventName, [dynamic data])`
5. `void dispose()`

### `SocketConnetParamX`

```dart
class SocketConnetParamX {
  final String? token;
  final String socketUrl;
  final String joinId;
}
```

`token` is optional. In authorized mode, if `token` is `null`, current stored auth token is used.

## Authorized Mode

Use `AuthorizedAppPigeon` when your API requires authentication and token refresh.

### Setup

```dart
import 'package:app_pigeon/app_pigeon.dart';

class MyRefreshTokenManager implements RefreshTokenManagerInterface {
  @override
  final String url = '/auth/refresh';

  @override
  Future<bool> shouldRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    return err.response?.statusCode == 401;
  }

  @override
  Future<RefreshTokenResponse> refreshToken({
    required String refreshToken,
    required Dio dio,
  }) async {
    final res = await dio.post(
      url,
      data: {'refreshToken': refreshToken},
    );
    final data = res.data['data'] as Map<String, dynamic>;
    return RefreshTokenResponse(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
      data: data,
    );
  }
}

final authorized = AuthorizedAppPigeon(
  MyRefreshTokenManager(),
  baseUrl: 'https://api.example.com',
);
```

### Save login auth

```dart
await authorized.saveNewAuth(
  saveAuthParams: SaveNewAuthParams(
    uid: userId,
    accessToken: accessToken,
    refreshToken: refreshToken,
    data: userData,
  ),
);
```

### Listen auth state

```dart
authorized.authStream.listen((status) {
  if (status is Authenticated) {
    // signed in
  } else if (status is UnAuthenticated) {
    // signed out
  }
});
```

### Account operations

```dart
final current = await authorized.getCurrentAuthRecord();
final all = await authorized.getAllAuthRecords();
await authorized.switchAccount(uid: 'user_2');
await authorized.logOut();
```

### Socket in authorized mode

```dart
await authorized.socketInit(
  SocketConnetParamX(
    token: null, // use stored token
    socketUrl: 'https://socket.example.com',
    joinId: 'global_chat',
  ),
);

authorized.listen('message').listen((event) {
  // handle incoming message
});

authorized.emit('message', {'text': 'hello'});
```

### Lifecycle notes

1. `dispose()` closes auth storage stream and socket.
2. If you only want to stop socket and keep auth storage alive, use:
   - `authorized.disconnectSocket()`

## Ghost Mode

Use `GhostAppPigeon` for anonymous/ghost flows where full auth persistence is not needed.

### Setup

```dart
final ghost = GhostAppPigeon(
  baseUrl: 'https://api.example.com',
);
```

### Optional token

```dart
ghost.setAuthToken('optional_token');
```

If set, ghost interceptor attaches `Authorization: Bearer <token>` on requests.

### HTTP and socket usage

```dart
final res = await ghost.post(
  '/chat/ghost/register',
  data: {'userName': 'ghostfox'},
);

await ghost.socketInit(
  SocketConnetParamX(
    token: null,
    socketUrl: 'https://socket.example.com',
    joinId: 'ghost_room',
  ),
);

ghost.listen('ghost_message').listen((event) {
  // handle ghost messages
});

ghost.emit('ghost_message', {
  'ghostId': 'ghost_ghostfox',
  'text': 'hello from ghost',
});
```

### Lifecycle notes

1. `dispose()` closes ghost socket resources.
2. If you only want to explicitly stop socket listeners/connection, use:
   - `ghost.disconnectSocket()`

## Dynamic Mode Switching

Common architecture in apps:

1. Keep one `AuthorizedAppPigeon`.
2. Keep one `GhostAppPigeon`.
3. Expose an app-level active resolver.
4. Repositories call the currently active client at runtime.

This pattern lets you switch seamlessly between:

1. authenticated identity
2. ghost identity

without rebuilding repository objects.

## Error Handling Behavior

### Authorized interceptor

1. Appends access token from current stored auth.
2. On configured unauthorized errors:
   - starts one refresh request
   - queues pending failed requests
   - updates auth storage with new tokens
   - retries queued requests
3. If refresh fails:
   - clears current auth
   - rejects queued requests

### Ghost interceptor

1. Attaches optional token if set.
2. Does not run refresh flow.

## Recommended Backend Contract

For best compatibility, backend should return refreshed tokens as:

```json
{
  "data": {
    "accessToken": "new_access",
    "refreshToken": "new_refresh"
  }
}
```

For ghost identity flows, typical endpoints:

1. `POST /chat/ghost/register`
2. `POST /chat/ghost/login`
3. `POST /chat/ghost/messages`
4. `GET /chat/ghost/messages`

## Minimal End-to-End Example

```dart
final authorized = AuthorizedAppPigeon(
  MyRefreshTokenManager(),
  baseUrl: 'https://api.example.com',
);
final ghost = GhostAppPigeon(baseUrl: 'https://api.example.com');

// Use authorized client
await authorized.post('/auth/login', data: {...});
await authorized.saveNewAuth(
  saveAuthParams: SaveNewAuthParams(
    uid: 'u1',
    accessToken: 'a1',
    refreshToken: 'r1',
    data: {'uid': 'u1'},
  ),
);

// Later switch to ghost flow
authorized.disconnectSocket();
final ghostSession = await ghost.post(
  '/chat/ghost/register',
  data: {'userName': 'ghostfox'},
);
await ghost.socketInit(
  SocketConnetParamX(
    token: null,
    socketUrl: 'https://socket.example.com',
    joinId: 'ghost_room',
  ),
);
```

## Example App

This repository includes an `example/` app and example backend showing:

1. authorized login/signup/refresh
2. multi-account switching
3. ghost identity flow
4. realtime universal chat

## Notes

1. Keep `RefreshTokenManagerInterface` implementation deterministic and side-effect free.
2. Always hash secret-like values on backend (for example ghost passkeys).
3. Do not trust sender identity from client payload; resolve identity on backend.
