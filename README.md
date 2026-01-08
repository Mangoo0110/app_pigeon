A simple auth-aware networking layer for Flutter apps.
Built on top of **Dio** and **flutter_secure_storage**.

**AppPigeon** takes care of **authenticated HTTP requests** so you don’t have to manually manage tokens, headers, and refresh logic.

---

## ✨ Features

- Automatically attaches auth headers to every request  
- Securely stores access & refresh tokens  
- Refreshes tokens when they expire  
- Keeps authentication state in sync across the app  
- Handles logout and auth cleanup correctly  
- Re-authenticates socket connections using the active auth token 

## 🔁 Basic Usage

### Constructor
```dart
import 'package:apppigeon/apppigeon.dart';

// 1️⃣ Implement the RefreshTokenManagerInterface
class MyRefreshTokenManager implements RefreshTokenManagerInterface {
  @override
  Future<RefreshTokenResponse> refreshToken(String refreshToken) async {
    // Your logic to call the refresh token API
    final response = await Dio().post(
      'https://api.example.com/refresh',
      data: {'refreshToken': refreshToken},
    );

    if (response.statusCode == 200) {
      return RefreshTokenResponse(
      accessToken: data["accessToken"], 
      refreshToken: data["refreshToken"],
      data: (data["userId"] != null) ? 
        {
          "userId": data["userId"],
        } : null
    );
    }

    return null; // return null if refresh failed
  }
}

// 2️⃣ Create an instance of AppPigeon
void main() {
  final refreshTokenManager = MyRefreshTokenManager();

  final appPigeon = AppPigeon(
    refreshTokenManager,
    baseUrl: 'https://api.example.com',
    onError: (error, stack) {
      print('AppPigeon error: $error');
      print(stack);
    },
  );
}
```

### Login and save auth

```dart
await appPigeon.saveNewAuth(
  saveAuthParams: SaveNewAuthParams(
    uid: userId,
    accessToken: accessToken,
    refreshToken: refreshToken,
    data: userData,
  ),
);
```

### Listen to auth state change

```dart
appPigeon.authStream.listen((status) {
  if (status is Authenticated) {
    // user logged in
  } else if (status is UnAuthenticated) {
    // user logged out
  }
});
```

### Make authorized requests
```dart
final response = await appPigeon.get('/profile');
```

### Socket usage
Initialize socket
```dart
await appPigeon.socketInit(
  SocketConnetParamX(
    socketUrl: 'https://socket.example.com',
    joinId: 'room_1',
  ),
);
```

### Listen to socket event
```dart
appPigeon.listen('message').listen((data) {
  // handle incoming message
});
```