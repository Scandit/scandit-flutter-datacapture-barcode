/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:scandit_flutter_datacapture_barcode/src/barcode_function_names.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode_info.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/barcode_method_handler.dart';
import 'package:scandit_flutter_datacapture_barcode/src/structured_append.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
// ignore: implementation_imports
import 'package:scandit_flutter_datacapture_core/src/internal/logging/logging_method_channel.dart';

import 'symbology.dart';

/// A recognized barcode.
///
/// Added in version 6.7.0
class Barcode implements Serializable {
  late Symbology _symbology;
  /// The symbology of the barcode.
  ///
  /// Added in version 6.7.0
  Symbology get symbology => _symbology;

  String? _data;
  /// The data of this code as a unicode string.
  ///
  /// For some types of barcodes/2d codes (for example Data Matrix, Aztec, Pdf417), the data may contain non-printable characters, characters that cannot be represented as unicode code points, or nul-bytes in the middle of the string. [Barcode.data] may be *null* for such codes. How invalid code points are handled is platform-specific and should not be relied upon. If your applications relies on scanning of such codes, use [Barcode.rawData] instead which is capable of representing this data without loss of information.
  ///
  /// Added in version 6.7.0
  String? get data => _data;

  late String _rawData;
  /// The raw data contained in the barcode.
  ///
  /// Use this property instead of [Barcode.data] if you are relying on binary-encoded data that cannot be represented as unicode strings.
  ///
  /// Unlike [Barcode.data] which returns the data in Unicode representation, the [Barcode.rawData] returns the data with the encoding that was used in the barcode. See [Barcode.encodingRanges] for more information.
  ///
  /// The raw data is base64 encoded as a string and might need to be decoded to be used.
  ///
  /// Added in version 6.7.0
  String get rawData => _rawData;

  String? _addOnData;
  /// If present, this property returns the add-on code (also known as extension code) associated with this barcode. See [Add-on Codes](https://docs.scandit.com/extension-codes) to understand how add-ons can be enabled.
  ///
  /// Added in version 6.7.0
  String? get addOnData => _addOnData;

  late List<EncodingRange> _encodingRanges;
  /// Array of encoding ranges. Each entry of the returned encoding array points into bytes of [Barcode.rawData] and indicates what encoding is used for these bytes. This information can then be used to convert the bytes to unicode, or other representations. For most codes, a single encoding range covers the whole data, but certain 2d symbologies, such as [Symbology.qr] allow to switch the encoding in the middle of the code.
  ///
  /// The returned encoding ranges are sorted from lowest to highest index. Each byte in [Barcode.rawData] is contained in exactly one range, e.g. there are no holes or overlapping ranges.
  ///
  /// Added in version 6.7.0
  List<EncodingRange> get encodingRanges => _encodingRanges;

  late Quadrilateral _location;
  /// The location of the code. The coordinates are in image-space, meaning that the coordinates correspond to actual pixels in the image. For display, the coordinates need first to be converted into screen-space using the data capture view. See the Coordinate Conversion Guide for details and examples.
  ///
  /// The meaning of the values of [Quadrilateral.topLeft] etc is such that the top left point corresponds to the top left corner of the barcode, independent of how the code is oriented in the image.
  ///
  /// If you use [BarcodeBatch] you should not use this location at all. Instead use the always up-to-date [TrackedBarcode.location].
  ///
  /// In case the feature is not licensed, a quadrilateral with all corners set to 0, 0 is returned.
  ///
  /// Added in version 6.7.0
  Quadrilateral get location => _location;

  late bool _isGS1DataCarrier;
  /// *True* for codes that carry GS1 data.
  ///
  /// Added in version 6.7.0
  bool get isGS1DataCarrier => _isGS1DataCarrier;

  late CompositeFlag _compositeFlag;
  /// Flag to hint whether the barcode is part of a composite code.
  ///
  /// Added in version 6.7.0
  CompositeFlag get compositeFlag => _compositeFlag;

  late bool _isColorInverted;
  /// Whether the recognized code is color inverted (printed bright on dark background).
  ///
  /// Added in version 6.7.0
  bool get isColorInverted => _isColorInverted;

  late int _symbolCount;
  /// The symbol count of this barcode. Use this value to determine the symbol count of a particular barcode, e.g. to configure the active symbol counts.
  ///
  /// Added in version 6.7.0
  int get symbolCount => _symbolCount;

  late int _frameID;
  /// Id of the frame from which this barcode information was obtained.
  ///
  /// Added in version 6.7.0
  int get frameID => _frameID;

  late int _moduleCountX;
  /// The number of modules in the X direction (horizontal) of the barcode.
  ///
  /// Added in version 8.3.0
  int get moduleCountX => _moduleCountX;

  late int _moduleCountY;
  /// The number of modules in the Y direction (vertical) of the barcode.
  ///
  /// Added in version 8.3.0
  int get moduleCountY => _moduleCountY;

  String? _compositeData;
  /// Added in version 6.7.0
  String? get compositeData => _compositeData;

  String? _compositeRawData;
  /// The raw data is base64 encoded as a string and might need to be decoded to be used.
  ///
  /// Added in version 6.7.0
  String? get compositeRawData => _compositeRawData;

  StructuredAppendData? _structuredAppendData;
  /// If present, this property returns the structured append data associated with this barcode. In structured append mode data is encoded across multiple 1D or 2D barcodes where each barcode contains only one segment of the complete data. Once all segment-containing barcodes are scanned the complete data can be read out.
  ///
  /// Only a few symbologies (pdf417, microPdf417, QR, DataMatrix, Aztec, DotCode, MaxiCode) can use this mode, and each has a different set of limitations, like included metadata or the maximum number of barcodes that can form a set.
  ///
  /// Added in version 6.25.0
  StructuredAppendData? get structuredAppendData => _structuredAppendData;

  /// Whether the barcode is a structured append barcode.
  ///
  /// Added in version 6.25.0
  bool get isStructuredAppend => _structuredAppendData != null;

  Barcode._(
      {required Symbology symbology,
      String? data,
      required String rawData,
      String? addOnData,
      required List<EncodingRange> encodingRanges,
      required Quadrilateral location,
      required bool isGS1DataCarrier,
      required CompositeFlag compositeFlag,
      required bool isColorInverted,
      required int symbolCount,
      required int frameID,
      required int moduleCountX,
      required int moduleCountY,
      String? compositeData,
      String? compositeRawData,
      StructuredAppendData? structuredAppendData}) {
    _symbology = symbology;
    _data = data;
    _rawData = rawData;
    _addOnData = addOnData;
    _encodingRanges = encodingRanges;
    _location = location;
    _isGS1DataCarrier = isGS1DataCarrier;
    _compositeFlag = compositeFlag;
    _isColorInverted = isColorInverted;
    _symbolCount = symbolCount;
    _frameID = frameID;
    _moduleCountX = moduleCountX;
    _moduleCountY = moduleCountY;
    _compositeData = compositeData;
    _compositeRawData = compositeRawData;
    _structuredAppendData = structuredAppendData;
  }

  factory Barcode.fromJSON(Map<String, dynamic> json) {
    var symbology = SymbologySerializer.fromJSON(json['symbology'] as String);
    var data = json['data'] as String?;
    var rawData = json['rawData'] as String;
    var addonData = json['addOnData'] as String?;
    var encodingRanges =
        (json['encodingRanges'] as List).map((e) => EncodingRange.fromJSON(e)).toList().cast<EncodingRange>();
    var location = Quadrilateral.fromJSON(json['location']);
    var isGS1DataCarrier = json['isGS1DataCarrier'] as bool;
    var compositeFlag = CompositeFlagDeserializer.fromJSON(json['compositeFlag'] as String);
    var isColorInverted = json['isColorInverted'] as bool;
    var symbolCount = (json['symbolCount'] as num).toInt();
    var frameID = (json['frameId'] as num).toInt();
    var moduleCountX = (json['moduleCountX'] as num?)?.toInt() ?? 0;
    var moduleCountY = (json['moduleCountY'] as num?)?.toInt() ?? 0;
    var compositeData = json['compositeData'] as String?;
    var compositeRawData = json['compositeRawData'] as String?;
    StructuredAppendData? structuredAppendData;
    if (json.containsKey('structuredAppendData') && json['structuredAppendData'] != null) {
      final jsonStructuredAppendData = json['structuredAppendData'] as Map<String, dynamic>;
      structuredAppendData = StructuredAppendData.fromJSON(jsonStructuredAppendData);
    }
    return Barcode._(
        symbology: symbology,
        data: data,
        rawData: rawData,
        addOnData: addonData,
        encodingRanges: encodingRanges,
        location: location,
        isGS1DataCarrier: isGS1DataCarrier,
        compositeFlag: compositeFlag,
        isColorInverted: isColorInverted,
        symbolCount: symbolCount,
        frameID: frameID,
        moduleCountX: moduleCountX,
        moduleCountY: moduleCountY,
        compositeData: compositeData,
        compositeRawData: compositeRawData,
        structuredAppendData: structuredAppendData);
  }

  /// Constructs a Barcode instance using the specified information.
  ///
  /// Added in version 8.3.0
  static Future<Barcode> create(BarcodeInfo info) async {
    final methodChannel = const LoggingMethodChannel(BarcodeFunctionNames.methodsChannelName);
    final methodHandler = BarcodeMethodHandler(methodChannel);
    final result = await methodHandler.createFromBarcodeInfo(barcodeInfoJson: jsonEncode(info.toMap()));
    return Barcode.fromJSON(jsonDecode(result));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'symbology': symbology.toString(),
      'data': data,
      'rawData': rawData,
      'addOnData': addOnData,
      'encodingRanges': encodingRanges.map((e) => e.toMap()).toList(),
      'location': location.toMap(),
      'isGS1DataCarrier': isGS1DataCarrier,
      'compositeFlag': compositeFlag.toString(),
      'isColorInverted': isColorInverted,
      'symbolCount': symbolCount,
      'frameId': frameID,
      'moduleCountX': moduleCountX,
      'moduleCountY': moduleCountY,
      'compositeData': compositeData,
      'compositeRawData': compositeRawData,
      'structuredAppendData': structuredAppendData?.toMap()
    };
  }
}

/// A barcode that was only localized but not recognized yet. This means there is no data or symbology associated with it.
///
/// Added in version 6.7.0
class LocalizedOnlyBarcode {
  Quadrilateral _location;
  /// The location of the code. The coordinates are in image-space, meaning that the coordinates correspond to actual pixels in the image. For display, the coordinates need first to be converted into screen-space.
  ///
  /// The meaning of the values of [Quadrilateral.topLeft] etc is such that the top left point corresponds to the top left corner of the barcode, independent of how the code is oriented in the image.
  ///
  /// In case the feature is not licensed, a quadrilateral with all corners set to 0, 0 is returned.
  ///
  /// Added in version 6.7.0
  Quadrilateral get location => _location;

  int _frameId;
  /// Id of the frame from which this barcode information was obtained.
  ///
  /// Added in version 6.7.0
  int get frameId => _frameId;

  LocalizedOnlyBarcode._(this._location, this._frameId);

  LocalizedOnlyBarcode.fromJSON(Map<String, dynamic> json)
      : this._(Quadrilateral.fromJSON(json['location']), (json['frameId'] as num).toInt());
}
