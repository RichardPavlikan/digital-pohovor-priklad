# Salary overview

Small Flutter client for the salary list assignment. It signs in against the
test API, shows the paged list of salaries and opens a detail screen for a
single record.

## Running

```
flutter pub get
flutter run
```

The login screen is pre-filled with the test account so you can just hit
**Sign in**.

## Structure

I went with a light clean-architecture split and BLoC/Cubit, which is roughly
what I'd use on a real project:

- `core/` – Dio client with the auth interceptor, token storage, shared error type
- `features/auth/` – login cubit + screen, auth repository
- `features/items/` – salary list and detail, repository, models
- `injection.dart` – GetIt wiring

State management is `flutter_bloc`, DI is `get_it`, networking is `dio`.

## Notes

The list is paged (page/limit) and loads more as you scroll. The token is kept
in `shared_preferences` and refreshed by the interceptor when the API returns
401, so the screens don't have to think about it.
