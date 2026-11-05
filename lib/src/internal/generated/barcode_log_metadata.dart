/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

// THIS FILE IS GENERATED. DO NOT EDIT MANUALLY.
// Generator: scripts/bridge_generator/generate.py
// Schema: scripts/bridge_generator/schemas/barcode.json

// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging.dart';

/// Per-method `LogRecord` level and category overrides for the Barcode
/// bridge surface. Consumed by `LoggingMethodChannel` (via
/// `ScanditLogger.getMethodMetadata`): per-frame / per-scan callbacks log at
/// [LogLevel.trace] under their category label, so they only show once the
/// level is raised to [LogLevel.trace] (mirrors the TS `wrapNativeProxy`
/// behaviour).
///
/// Keys are the **bare** method name, matching the TS `*ProxyLogMetadata.ts`
/// maps and the native `message` of records received over the batch channel.
///
/// Unlike the TS/JS side, Dart has no import-side-effect auto-registration:
/// an unimported file simply never runs. [registerBarcodeLogMetadata]
/// must therefore be called explicitly — done once, from this plugin's own
/// bootstrap (`ScanditFlutterDataCaptureBarcode.initialize()`).
const Map<String, MethodLogMetadata> barcodeLogMetadata = {
  'finishBarcodeCaptureDidUpdateSession': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeCaptureDidScan': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeSelectionDidSelect': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeSelectionDidUpdateSession': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBrushForAimedBarcodeCallback': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBrushForTrackedBarcodeCallback': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeBatchDidUpdateSessionCallback': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeCountBrushForRecognizedBarcode': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeCountBrushForRecognizedBarcodeNotInList':
      MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeCountBrushForAcceptedBarcode': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeCountBrushForRejectedBarcode': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeCountOnScan': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeCountOnSessionUpdated': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishSparkScanDidUpdateSession': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishSparkScanDidScan': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishPickAction': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishOnProductIdentifierForItems': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodePickViewHighlightStyleCustomViewProviderViewForRequest':
      MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodePickViewHighlightStyleAsyncProviderStyleForRequest':
      MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeArFilterBarcodes': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeArAnnotationForBarcode': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeArHighlightForBarcode': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
  'finishBarcodeArOnDidUpdateSession': MethodLogMetadata(level: LogLevel.trace, category: LogCategory.events),
};

/// Registers [barcodeLogMetadata] with [ScanditLogger]. Idempotent by
/// construction — it merges a `const` map of fixed keys, so calling it every
/// time this plugin's `initialize()` runs (e.g. once per dependent plugin
/// that bootstraps this one first) re-writes identical entries.
void registerBarcodeLogMetadata() {
  ScanditLogger.registerMethodMetadata(barcodeLogMetadata);
}
