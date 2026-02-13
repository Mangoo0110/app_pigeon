# app_pigeon Example Backend

Simple demo backend for testing app_pigeon auth and refresh flows.

## Endpoints
- `POST /auth/login` -> returns access + refresh tokens
- `POST /auth/refresh` -> returns new tokens
- `GET /profile` -> requires `Authorization: Bearer <token>`
- `GET /health`

## Run locally
```bash
cd example/backend
npm install
npm start
```

Optional config:
- Copy `.env.example` to `.env` and adjust values.
