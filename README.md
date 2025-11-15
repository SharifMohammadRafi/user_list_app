# User List App (Flutter)

A simple Flutter app demonstrating Clean Architecture, Riverpod state management, API pagination, search, offline caching, pull-to-refresh, and robust error handling.

## Tech
- Riverpod (StateNotifier)
- Dio (HTTP + timeouts)
- Clean Architecture (data/domain/presentation)
- Infinite scroll with `reqres.in`
- Local search (works offline)
- SharedPreferences for caching (TTL 1 hour)
- connectivity_plus for offline status
- get_it for dependency injection
- cached_network_image for avatars

## Features
- User List screen with search
- Detail screen (name, email, phone)
- Infinite pagination using `?per_page=10&page=1`
- Pull to refresh
- Offline fallback to cached data
- Loading states, timeouts, retry
- Empty states
- Responsive layout

## Getting Started
1. Flutter SDK installed (3.22+ recommended)
2. `flutter pub get`
3. `flutter run`

## Notes
- The `phone` field is not provided by reqres; we generate a deterministic demo phone.
- Cache TTL is 1 hour. Pull-to-refresh always fetches fresh data.
- Search is case-insensitive and trims/normalizes spaces.

## Tests (optional)
- You can add unit tests for the repository and widget tests for the list page.