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

## What I'd add with more time

- Proper error/empty states instead of the basic ones I have now
- A logout button and a real "remember me" instead of the hard-coded account
- Widget tests for the list and login flows (only added a couple of unit tests)
- Pull config (base URL, credentials) out of the code and into an env file

Spent a bit longer than I meant to on the interceptor. Happy to walk through
any of it.
