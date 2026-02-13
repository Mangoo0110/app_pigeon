## 0.1.4
- Refactored core client architecture with a shared `AppPigeon` contract and separated runtime clients for authorized and ghost flows.
- Renamed authorized client surface to `AuthorizedPigeon` and introduced `Authorization` abstraction for token persistence operations.
- Improved refresh-token integration with a concrete `BasicRefreshTokenManager` refresh implementation example.
- Added request-queue handling in the API interceptor to coordinate token refresh and pending request replay.
- Added `shouldRefreshToken` support in refresh manager interfaces/implementations for safer refresh conditions.
- Expanded package documentation with updated setup and usage guidance for the new client and authorization model.


## 0.1.3
- Updated README with refresh-token-manager-interface implementation example
