/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

abstract class BarcodeGeneratorFunctionNames {
  static const String generateFromData = 'generateFromBase64EncodedDataToBytes';
  static const String generateFromText = 'generateFromStringToBytes';
  static const String dispose = 'disposeBarcodeGenerator';
  static const String create = 'createBarcodeGenerator';

  static const String methodsChannelName = 'com.scandit.datacapture.barcode.generator/method_channel';
}
