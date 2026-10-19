/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

abstract class BarcodeFindConstants {
  static const String onSearchStartedEvent = 'BarcodeFindListener.onSearchStarted';
  static const String onSearchPausedEvent = 'BarcodeFindListener.onSearchPaused';
  static const String onSearchStoppedEvent = 'BarcodeFindListener.onSearchStopped';
  static const String onTransformBarcodeData = 'BarcodeFindTransformer.transformBarcodeData';
  static const String onFinishButtonTappedEventName = 'BarcodeFindViewUiListener.onFinishButtonTapped';
}
