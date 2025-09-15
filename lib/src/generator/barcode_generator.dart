/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'barcode_generator_function_names.dart';
import 'qr_code_crrection_level.dart';

class BarcodeGenerator extends Serializable implements DataCaptureComponent {
  final String _id = DateTime.now().microsecondsSinceEpoch.toString().padLeft(20, '0');

  final String _type;

  final _BarcodeGeneratorCreationOptions _options;

  late _BarcodeGeneratorController _controller;

  BarcodeGenerator._(this._type, this._options) {
    _controller = _BarcodeGeneratorController(this);
    _controller.create();
  }

  @override
  String get id => _id;

  Future<Image> generateFromData(Uint8List data, double imageWidth) {
    return _controller.generateFromData(data, imageWidth);
  }

  Future<Image> generateFromText(String text, double imageWidth) async {
    return _controller.generateFromText(text, imageWidth);
  }

  static Code39BarcodeGeneratorBuilder code39BarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return Code39BarcodeGeneratorBuilder._();
  }

  static Code128BarcodeGeneratorBuilder code128BarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return Code128BarcodeGeneratorBuilder._();
  }

  static Ean13BarcodeGeneratorBuilder ean13BarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return Ean13BarcodeGeneratorBuilder._();
  }

  static UpcaBarcodeGeneratorBuilder upcaBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return UpcaBarcodeGeneratorBuilder._();
  }

  static InterleavedTwoOfFiveBarcodeGeneratorBuilder interleavedTwoOfFiveBarcodeGeneratorBuilder(
      DataCaptureContext dataCaptureContext) {
    return InterleavedTwoOfFiveBarcodeGeneratorBuilder._();
  }

  static QrCodeBarcodeGeneratorBuilder qrCodeBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return QrCodeBarcodeGeneratorBuilder._();
  }

  static DataMatrixBarcodeGeneratorBuilder dataMatrixBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return DataMatrixBarcodeGeneratorBuilder._();
  }

  static AztecBarcodeGeneratorBuilder aztecBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return AztecBarcodeGeneratorBuilder._();
  }

  // Method to dispose of the barcode generator
  void dispose() {
    _controller.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': _type,
      'id': _id,
      'errorCorrectionLevel': _options.errorCorrectionLevel?.name,
      'versionNumber': _options.versionNumber,
      'minimumErrorCorrectionPercent': _options.minimumErrorCorrectionPercent,
      'layers': _options.layers,
      'backgroundColor': _options.backgroundColor?.jsonValue,
      'foregroundColor': _options.foregroundColor?.jsonValue,
    };
  }
}

class BarcodeGeneratorBuilder<T> {
  final String _type;
  final _BarcodeGeneratorCreationOptions _options = _BarcodeGeneratorCreationOptions();

  BarcodeGeneratorBuilder._(this._type);

  T withBackgroundColor(Color backgroundColor) {
    _options.backgroundColor = backgroundColor;
    return this as T;
  }

  T withForegroundColor(Color foregroundColor) {
    _options.foregroundColor = foregroundColor;
    return this as T;
  }

  BarcodeGenerator build() {
    return BarcodeGenerator._(_type, _options);
  }
}

class Code39BarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<Code39BarcodeGeneratorBuilder> {
  Code39BarcodeGeneratorBuilder._() : super._('code39Generator');
}

class Code128BarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<Code128BarcodeGeneratorBuilder> {
  Code128BarcodeGeneratorBuilder._() : super._('code128Generator');
}

class InterleavedTwoOfFiveBarcodeGeneratorBuilder
    extends BarcodeGeneratorBuilder<InterleavedTwoOfFiveBarcodeGeneratorBuilder> {
  InterleavedTwoOfFiveBarcodeGeneratorBuilder._() : super._('interleavedTwoOfFiveGenerator');
}

class Ean13BarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<Ean13BarcodeGeneratorBuilder> {
  Ean13BarcodeGeneratorBuilder._() : super._('ean13Generator');
}

class UpcaBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<UpcaBarcodeGeneratorBuilder> {
  UpcaBarcodeGeneratorBuilder._() : super._('upcaGenerator');
}

class DataMatrixBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<DataMatrixBarcodeGeneratorBuilder> {
  DataMatrixBarcodeGeneratorBuilder._() : super._('dataMatrixGenerator');
}

class QrCodeBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<QrCodeBarcodeGeneratorBuilder> {
  QrCodeBarcodeGeneratorBuilder._() : super._('qrCodeGenerator');

  QrCodeBarcodeGeneratorBuilder withErrorCorrectionLevel(QrCodeErrorCorrectionLevel errorCorrectionLevel) {
    _options.errorCorrectionLevel = errorCorrectionLevel;
    return this;
  }

  QrCodeBarcodeGeneratorBuilder withVersionNumber(int versionNumber) {
    _options.versionNumber = versionNumber;
    return this;
  }
}

class AztecBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<AztecBarcodeGeneratorBuilder> {
  AztecBarcodeGeneratorBuilder._() : super._('aztecGenerator');

  AztecBarcodeGeneratorBuilder withMinimumErrorCorrectionPercent(int minimumErrorCorrectionPercent) {
    _options.minimumErrorCorrectionPercent = minimumErrorCorrectionPercent;
    return this;
  }

  AztecBarcodeGeneratorBuilder withLayers(int layers) {
    _options.layers = layers;
    return this;
  }
}

class _BarcodeGeneratorController extends BaseController {
  final BarcodeGenerator barcodeGenerator;

  _BarcodeGeneratorController(this.barcodeGenerator) : super(BarcodeGeneratorFunctionNames.methodsChannelName);

  Future<Image> generateFromData(Uint8List data, double imageWidth) async {
    var result = await methodChannel.invokeMethod<Uint8List>(BarcodeGeneratorFunctionNames.generateFromData, {
      'generatorId': barcodeGenerator.id,
      'data': data,
      'imageWidth': imageWidth,
    });
    if (result == null) {
      throw Exception('Failed to generate barcode');
    }
    return Image.memory(result, width: imageWidth);
  }

  Future<Image> generateFromText(String text, double imageWidth) async {
    var result = await methodChannel.invokeMethod<Uint8List>(BarcodeGeneratorFunctionNames.generateFromText, {
      'generatorId': barcodeGenerator.id,
      'text': text,
      'imageWidth': imageWidth,
    });
    if (result == null) {
      throw Exception('Failed to generate barcode');
    }
    return Image.memory(result, width: imageWidth);
  }

  @override
  void dispose() {
    methodChannel.invokeMethod(BarcodeGeneratorFunctionNames.dispose, {'generatorId': barcodeGenerator.id});
    super.dispose();
  }

  void create() {
    methodChannel.invokeMethod(BarcodeGeneratorFunctionNames.create, jsonEncode(barcodeGenerator.toMap()));
  }
}

class _BarcodeGeneratorCreationOptions {
  Color? backgroundColor;
  Color? foregroundColor;
  QrCodeErrorCorrectionLevel? errorCorrectionLevel;
  int? versionNumber;
  int? minimumErrorCorrectionPercent;
  int? layers;

  _BarcodeGeneratorCreationOptions();
}
