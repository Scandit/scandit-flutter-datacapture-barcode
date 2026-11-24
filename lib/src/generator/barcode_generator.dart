/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/base_controller.dart';

import 'qr_code_crrection_level.dart';

/// Added in version 7.2.0
class BarcodeGenerator extends Serializable implements DataCaptureComponent {
  final String _id = DateTime.now().microsecondsSinceEpoch.toString().padLeft(20, '0');

  final String _type;

  final _BarcodeGeneratorCreationOptions _options;

  late _BarcodeGeneratorController _controller;

  BarcodeGenerator._(this._type, this._options) {
    _controller = _BarcodeGeneratorController(this);
    _controller.create();
  }

  /// Gets the data capture component ID for the barcode generator.
  ///
  /// Added in version 7.2.0
  @override
  String get id => _id;

  /// Generate a code of the given width for the supplied data. If the data is not compatible with the generator’s symbology, an exception is thrown.
  ///
  /// imageWidth specifies the width of the image in pixels.
  ///
  /// When running on iOS, the resulting UIImage will use the same scale as the device screen.
  ///
  /// Added in version 7.2.0
  Future<Image> generateFromData(Uint8List data, double imageWidth) {
    return _controller.generateFromData(data, imageWidth);
  }

  /// Generate a code of the given width for the supplied text. If the text is not compatible with the generator’s symbology, an exception is thrown.
  ///
  /// imageWidth specifies the width of the image in pixels.
  ///
  /// When running on iOS, the resulting UIImage will use the same scale as the device screen.
  ///
  /// Added in version 7.2.0
  Future<Image> generateFromText(String text, double imageWidth) async {
    return _controller.generateFromText(text, imageWidth);
  }

  /// Creates a Code 39 Barcode Generator builder for the provided context.
  ///
  /// Added in version 7.2.0
  static Code39BarcodeGeneratorBuilder code39BarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return Code39BarcodeGeneratorBuilder._();
  }

  /// Creates a Code 128 Barcode Generator builder for the provided context.
  ///
  /// Added in version 7.2.0
  static Code128BarcodeGeneratorBuilder code128BarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return Code128BarcodeGeneratorBuilder._();
  }

  /// Creates an EAN13 Barcode Generator builder for the provided context.
  ///
  /// EAN13 codes are composed of 13 symbols. If 12 symbols are provided, it is assumed that the checksum is missing and it is generated and appended to the end.
  ///
  /// Added in version 7.2.0
  static Ean13BarcodeGeneratorBuilder ean13BarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return Ean13BarcodeGeneratorBuilder._();
  }

  /// Creates a UPCA Barcode Generator builder for the provided context.
  ///
  /// Added in version 7.2.0
  static UpcaBarcodeGeneratorBuilder upcaBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return UpcaBarcodeGeneratorBuilder._();
  }

  /// Creates an Interleaved Two-of-Five Barcode Generator builder for the provided context.
  ///
  /// Added in version 7.2.0
  static InterleavedTwoOfFiveBarcodeGeneratorBuilder interleavedTwoOfFiveBarcodeGeneratorBuilder(
      DataCaptureContext dataCaptureContext) {
    return InterleavedTwoOfFiveBarcodeGeneratorBuilder._();
  }

  /// Creates a QRCode Barcode Generator builder for the provided context.
  ///
  /// Added in version 7.2.0
  static QrCodeBarcodeGeneratorBuilder qrCodeBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return QrCodeBarcodeGeneratorBuilder._();
  }

  /// Creates a DataMatrix Barcode Generator builder for the provided context.
  ///
  /// Added in version 7.2.0
  static DataMatrixBarcodeGeneratorBuilder dataMatrixBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return DataMatrixBarcodeGeneratorBuilder._();
  }

  /// Creates an Aztec Barcode Generator builder for the provided context.
  ///
  /// Added in version 7.2.0
  static AztecBarcodeGeneratorBuilder aztecBarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return AztecBarcodeGeneratorBuilder._();
  }

  /// Creates a PDF417 Barcode Generator builder for the provided context.
  ///
  /// Added in version 8.4.0
  static Pdf417BarcodeGeneratorBuilder pdf417BarcodeGeneratorBuilder(DataCaptureContext dataCaptureContext) {
    return Pdf417BarcodeGeneratorBuilder._();
  }

  // Method to dispose of the barcode generator
  /// Disposes the barcode generator.
  ///
  /// Added in version 7.2.0
  void dispose() {
    _controller.dispose();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': _type,
      'id': _id,
      'errorCorrectionLevel': _options.pdf417ErrorCorrectionLevel ?? _options.errorCorrectionLevel?.name,
      'versionNumber': _options.versionNumber,
      'minimumErrorCorrectionPercent': _options.minimumErrorCorrectionPercent,
      'layers': _options.layers,
      'backgroundColor': _options.backgroundColor?.jsonValue,
      'foregroundColor': _options.foregroundColor?.jsonValue,
      'compact': _options.compact,
      'compactionMode': _options.compactionMode?.name,
      'dimensions': _options.dimensions != null
          ? {
              'minCols': _options.dimensions!.minCols,
              'maxCols': _options.dimensions!.maxCols,
              'minRows': _options.dimensions!.minRows,
              'maxRows': _options.dimensions!.maxRows,
            }
          : null,
    };
  }
}

/// Added in version 7.2.0
class BarcodeGeneratorBuilder<T> {
  final String _type;
  final _BarcodeGeneratorCreationOptions _options = _BarcodeGeneratorCreationOptions();

  BarcodeGeneratorBuilder._(this._type);

  /// Sets the background color for the generated codes. Default is Color.WHITE.
  ///
  /// Added in version 7.2.0
  T withBackgroundColor(Color backgroundColor) {
    _options.backgroundColor = backgroundColor;
    return this as T;
  }

  /// Sets the foreground color for the generated codes. Default is Color.BLACK.
  ///
  /// Added in version 7.2.0
  T withForegroundColor(Color foregroundColor) {
    _options.foregroundColor = foregroundColor;
    return this as T;
  }

  /// Constructs a [BarcodeGenerator] with the properties set on the builder.
  ///
  /// Added in version 7.2.0
  BarcodeGenerator build() {
    return BarcodeGenerator._(_type, _options);
  }
}

/// Added in version 7.2.0
class Code39BarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<Code39BarcodeGeneratorBuilder> {
  Code39BarcodeGeneratorBuilder._() : super._('code39Generator');
}

/// Added in version 7.2.0
class Code128BarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<Code128BarcodeGeneratorBuilder> {
  Code128BarcodeGeneratorBuilder._() : super._('code128Generator');
}

/// Added in version 7.2.0
class InterleavedTwoOfFiveBarcodeGeneratorBuilder
    extends BarcodeGeneratorBuilder<InterleavedTwoOfFiveBarcodeGeneratorBuilder> {
  InterleavedTwoOfFiveBarcodeGeneratorBuilder._() : super._('interleavedTwoOfFiveGenerator');
}

/// Added in version 7.2.0
class Ean13BarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<Ean13BarcodeGeneratorBuilder> {
  Ean13BarcodeGeneratorBuilder._() : super._('ean13Generator');
}

/// Added in version 7.2.0
class UpcaBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<UpcaBarcodeGeneratorBuilder> {
  UpcaBarcodeGeneratorBuilder._() : super._('upcaGenerator');
}

/// Added in version 7.2.0
class DataMatrixBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<DataMatrixBarcodeGeneratorBuilder> {
  DataMatrixBarcodeGeneratorBuilder._() : super._('dataMatrixGenerator');
}

/// Added in version 7.2.0
class QrCodeBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<QrCodeBarcodeGeneratorBuilder> {
  QrCodeBarcodeGeneratorBuilder._() : super._('qrCodeGenerator');

  /// Configure how much error correction to use in the generated code.
  ///
  /// Added in version 7.2.0
  QrCodeBarcodeGeneratorBuilder withErrorCorrectionLevel(QrCodeErrorCorrectionLevel errorCorrectionLevel) {
    _options.errorCorrectionLevel = errorCorrectionLevel;
    return this;
  }

  /// The version number for the QR code. Version number determines the size of the QR code, with a larger size allowing more data to be stored. The value must be greater than 0, and if the value is too small for the data being encoded, code generation will fail.
  ///
  /// Added in version 7.2.0
  QrCodeBarcodeGeneratorBuilder withVersionNumber(int versionNumber) {
    _options.versionNumber = versionNumber;
    return this;
  }
}

/// Added in version 7.2.0
class AztecBarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<AztecBarcodeGeneratorBuilder> {
  AztecBarcodeGeneratorBuilder._() : super._('aztecGenerator');

  /// Optional parameter to configure how much error correction to use in the generated code. The value must be greater than 0.
  ///
  /// Added in version 7.2.0
  AztecBarcodeGeneratorBuilder withMinimumErrorCorrectionPercent(int minimumErrorCorrectionPercent) {
    _options.minimumErrorCorrectionPercent = minimumErrorCorrectionPercent;
    return this;
  }

  /// Optional parameter to configure how many layers, each one containing two rings of pixels, to use in the generated code. The value must be between -4 and 32. Negative values create compact codes.
  ///
  /// Added in version 7.2.0
  AztecBarcodeGeneratorBuilder withLayers(int layers) {
    _options.layers = layers;
    return this;
  }
}

/// The compaction mode for PDF417 barcode generation. The compaction mode determines how the data is encoded in the barcode.
///
/// Added in version 8.4.0
enum Pdf417CompactionMode {
  /// Automatically select the best compaction mode based on the input data. This is the default mode.
  ///
  /// Added in version 8.4.0
  auto,
  /// Text compaction mode, optimized for alphanumeric data. This mode is efficient for encoding text with letters, numbers, and common punctuation.
  ///
  /// Added in version 8.4.0
  text,
  /// Byte compaction mode, can encode any 8-bit byte data. This mode provides the most flexibility but may be less efficient for text data.
  ///
  /// Added in version 8.4.0
  byte,
  /// Numeric compaction mode, optimized for numeric data. This mode is most efficient when encoding only numbers.
  ///
  /// Added in version 8.4.0
  numeric,
}

/// Dimensions configuration for PDF417 barcode generation. This class allows you to control the minimum and maximum number of rows and columns in the generated barcode. All properties are optional and can be left unset (null).
///
/// Encoding will fail if incompatible dimensions are defined (e.g., if the data cannot fit within the specified constraints).
///
/// Added in version 8.4.0
class Pdf417Dimensions {
  /// Minimum number of columns in the PDF417 barcode. Default is null (unset).
  ///
  /// Added in version 8.4.0
  final int? minCols;
  /// Maximum number of columns in the PDF417 barcode. Default is null (unset).
  ///
  /// Added in version 8.4.0
  final int? maxCols;
  /// Minimum number of rows in the PDF417 barcode. Default is null (unset).
  ///
  /// Added in version 8.4.0
  final int? minRows;
  /// Maximum number of rows in the PDF417 barcode. Default is null (unset).
  ///
  /// Added in version 8.4.0
  final int? maxRows;

  /// Creates a new PDF417Dimensions instance with all properties set to null.
  ///
  /// Added in version 8.4.0
  const Pdf417Dimensions({int? minCols, int? maxCols, int? minRows, int? maxRows})
      : this._(
          minCols: minCols,
          maxCols: maxCols,
          minRows: minRows,
          maxRows: maxRows,
        );

  const Pdf417Dimensions._({this.minCols, this.maxCols, this.minRows, this.maxRows});
}

/// Added in version 8.4.0
class Pdf417BarcodeGeneratorBuilder extends BarcodeGeneratorBuilder<Pdf417BarcodeGeneratorBuilder> {
  Pdf417BarcodeGeneratorBuilder._() : super._('pdf417Generator');

  /// Sets the error correction level for PDF417 barcode generation. Valid values are 0 to 8, where a higher number increases the error correction data in the code. Default is 2.
  ///
  /// Added in version 8.4.0
  Pdf417BarcodeGeneratorBuilder withErrorCorrectionLevel(int errorCorrectionLevel) {
    _options.pdf417ErrorCorrectionLevel = errorCorrectionLevel;
    return this;
  }

  /// Switches between normal and compact code layout. When set to true, a compact PDF417 code is generated, which reduces the size but may decrease scanning reliability. Default is false.
  ///
  /// Added in version 8.4.0
  Pdf417BarcodeGeneratorBuilder withCompact(bool compact) {
    _options.compact = compact;
    return this;
  }

  /// Sets the compaction mode for PDF417 barcode generation. The compaction mode determines how the data is encoded. Default is [Pdf417CompactionMode.auto].
  ///
  /// Added in version 8.4.0
  Pdf417BarcodeGeneratorBuilder withCompactionMode(Pdf417CompactionMode compactionMode) {
    _options.compactionMode = compactionMode;
    return this;
  }

  /// Sets the symbol dimensions for the PDF417 barcode. The dimensions control the minimum and maximum number of rows and columns. Encoding fails if incompatible dimensions are defined.
  ///
  /// Added in version 8.4.0
  Pdf417BarcodeGeneratorBuilder withDimensions(Pdf417Dimensions dimensions) {
    _options.dimensions = dimensions;
    return this;
  }
}

class _BarcodeGeneratorController extends BaseController {
  final BarcodeGenerator barcodeGenerator;
  late final BarcodeMethodHandler barcodeMethodHandler;

  _BarcodeGeneratorController(this.barcodeGenerator) : super(BarcodeFunctionNames.methodsChannelName) {
    barcodeMethodHandler = BarcodeMethodHandler(methodChannel);
  }

  Future<Image> generateFromData(Uint8List data, double imageWidth) async {
    final result = await barcodeMethodHandler.generateFromBase64EncodedDataToBytes(
        generatorId: barcodeGenerator.id, data: data, imageWidth: imageWidth.toInt());
    if (result == null) {
      throw Exception('Failed to generate barcode');
    }
    return Image.memory(result, width: imageWidth);
  }

  Future<Image> generateFromText(String text, double imageWidth) async {
    final result = await barcodeMethodHandler.generateFromStringToBytes(
        generatorId: barcodeGenerator.id, text: text, imageWidth: imageWidth.toInt());
    if (result == null) {
      throw Exception('Failed to generate barcode');
    }
    return Image.memory(result, width: imageWidth);
  }

  @override
  void dispose() {
    barcodeMethodHandler.disposeBarcodeGenerator(generatorId: barcodeGenerator.id);
    super.dispose();
  }

  void create() {
    barcodeMethodHandler.createBarcodeGenerator(barcodeGeneratorJson: jsonEncode(barcodeGenerator.toMap()));
  }
}

class _BarcodeGeneratorCreationOptions {
  Color? backgroundColor;
  Color? foregroundColor;
  QrCodeErrorCorrectionLevel? errorCorrectionLevel;
  int? versionNumber;
  int? minimumErrorCorrectionPercent;
  int? layers;
  int? pdf417ErrorCorrectionLevel;
  bool? compact;
  Pdf417CompactionMode? compactionMode;
  Pdf417Dimensions? dimensions;

  _BarcodeGeneratorCreationOptions();
}
