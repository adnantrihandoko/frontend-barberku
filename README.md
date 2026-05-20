# barberku_app

Digital queue system for barbershop - Customer & Admin mobile app built with Flutter.

## Tech Stack

- **Framework:** Flutter 3.22+ (Dart 3.5+)
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Real-time:** WebSocket (web_socket_channel)
- **Architecture:** Clean Architecture (Presentation - Domain - Data)

## Project Structure

```
lib/
├── core/                 # Theme, constants, routing, providers, utils
├── features/             # Feature modules (queue, auth, history, profile)
│   └── queue/
│       ├── data/         # Datasources, models, repositories
│       ├── domain/       # Entities, usecases, repository interfaces
│       └── presentation/ # Providers, screens, widgets
└── shared/               # Reusable widgets, models, theme
```

## Getting Started

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Run code generation (Riverpod, JSON serializable):
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Configuration

Set environment variables for API endpoints:

```bash
flutter run --dart-define=API_BASE_URL=http://your-server:8080 --dart-define=WS_BASE_URL=ws://your-server:8080/ws
```

## Features

- Real-time queue monitoring via WebSocket
- Join queue with service & barber selection
- Floating bottom navigation bar with Material 3
- Light & dark theme support
- Queue history tracking
