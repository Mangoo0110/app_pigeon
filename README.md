
**AppPigeon** is a Flutter package that takes care of **authenticated HTTP requests** so you don’t have to manually manage tokens, headers, and refresh logic.

A simple auth-aware networking layer for Flutter apps.
Built on top of **Dio** and **flutter_secure_storage**.

---

## ✨ Features

- Automatically attaches auth headers to every request  
- Securely stores access & refresh tokens  
- Refreshes tokens when they expire  
- Keeps authentication state in sync across the app  
- Handles logout and auth cleanup correctly  
- Re-authenticates socket connections using the active auth token 