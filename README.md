# Camera Locations

A Flutter app that captures photos with GPS location data stamped directly onto the image. Uses Mapbox Geocoding API for reverse geocoding and GetX for state management.

## Features

- **Live camera preview** with real-time GPS HUD overlay (coordinates, accuracy)
- **Reverse geocoding** via Mapbox API (falls back to the `geocoding` package)
- **Image stamping** — timestamp, place name, lat/lng, and accuracy are drawn onto the photo
- **GPS diagnostic screen** — standalone tool to evaluate GPS fix quality before capturing

## Architecture

Built with the **GetX** modular pattern:

```
lib/
├── main.dart
└── app/
    ├── config/
    │   └── mapbox_config.dart       # Mapbox token (from --dart-define)
    ├── routes/
    │   ├── app_pages.dart           # Route table
    │   └── app_routes.dart          # Route name constants
    └── modules/
        ├── home/                    # Camera + capture screen
        │   ├── bindings/
        │   ├── controllers/
        │   └── views/
        └── location/                # GPS diagnostic screen
            ├── bindings/
            ├── controllers/
            └── views/
```

## Getting Started

### Prerequisites

- Flutter SDK >= 3.11.0
- Android / iOS device or emulator with a camera

### Mapbox Access Token

This app requires a **Mapbox access token** with the Geocoding API enabled. Get one at [mapbox.com](https://account.mapbox.com/).

Pass the token at build/run time:

```bash
flutter run --dart-define=MAPBOX_ACCESS_TOKEN=YOUR_TOKEN_HERE
```

For release builds:

```bash
flutter build apk --dart-define=MAPBOX_ACCESS_TOKEN=YOUR_TOKEN_HERE
flutter build ios --dart-define=MAPBOX_ACCESS_TOKEN=YOUR_TOKEN_HERE
```

> **Warning:** Never hardcode secrets in source code. The token is read at compile time via `String.fromEnvironment`.

### iOS Setup

Add the following keys to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Needed to take photos with location</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Needed to save photos</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Needed to stamp GPS location on photos</string>
```

### Android Setup

Required permissions are declared in `android/app/src/main/AndroidManifest.xml`:
- `CAMERA`
- `ACCESS_FINE_LOCATION`
- `INTERNET`

### Run the App

```bash
flutter pub get
flutter run --dart-define=MAPBOX_ACCESS_TOKEN=YOUR_TOKEN_HERE
```

## Dependencies

| Package | Purpose |
|---|---|
| `get` | State management & routing |
| `camera` | Camera preview & capture |
| `geolocator` | GPS location services |
| `geocoding` | Fallback reverse geocoding |
| `http` | Mapbox API client |
| `image` | Image decoding & text overlay |
| `intl` | Date formatting |
| `gal` | Gallery saving (not yet wired) |

## Usage

1. Grant camera and location permissions when prompted.
2. The camera opens with a HUD showing current GPS coordinates and accuracy.
3. Tap the shutter button to capture. A preview appears with **Jaribu Tena** (Retry) and **Tumia Picha Hii** (Use This Photo) options.
4. The confirmed photo has location data stamped on it and is returned as a base64 string with lat/lng metadata.
