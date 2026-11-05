# scandit_flutter_datacapture_barcode

Barcode scanning for Flutter, built on the Scandit Data Capture SDK. It reads a large number of barcode symbologies and includes SparkScan, MatrixScan and other scanning modes.

## Requirements

- Flutter 3.22.0 or later
- Android minSdk 24 or later
- Android Gradle Plugin 8.1.4, Kotlin 1.8.22 and Gradle 8.2 or later, with Java 17
- iOS 15.0 or later

## Installation

```sh
flutter pub add scandit_flutter_datacapture_barcode
```

## Documentation

See the [Scandit Flutter documentation](https://docs.scandit.com/sdks/flutter/).

## Samples

Get started with the [Scandit Flutter samples](https://github.com/Scandit/datacapture-flutter-samples).

## Using a coding agent

Install the Scandit skills to help your coding agent build with this package:

```sh
npx plugins add scandit/skills
```

This detects the coding agents you have and installs into each. To install from your agent's own marketplace instead (Claude Code, Cursor, Codex, Copilot CLI), see the [Scandit skills installation guide](https://github.com/Scandit/skills#installation).

Skills for this package:

- `barcode-capture-flutter`
- `sparkscan-flutter`
- `matrixscan-ar-flutter`
- `matrixscan-batch-flutter`
- `matrixscan-count-flutter`
