/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'symbology.dart';

class Barcode implements Serializable {
  late Symbology _symbology;
  Symbology get symbology => _symbology;

  String? _data;
  String? get data => _data;

  late String _rawData;
  String get rawData => _rawData;

  String? _addOnData;
  String? get addOnData => _addOnData;

  late List<EncodingRange> _encodingRanges;
  List<EncodingRange> get encodingRanges => _encodingRanges;

  late Quadrilateral _location;
  Quadrilateral get location => _location;

  late bool _isGS1DataCarrier;
  bool get isGS1DataCarrier => _isGS1DataCarrier;

  late CompositeFlag _compositeFlag;
  CompositeFlag get compositeFlag => _compositeFlag;

  late bool _isColorInverted;
  bool get isColorInverted => _isColorInverted;

  late int _symbolCount;
  int get symbolCount => _symbolCount;

  late int _frameID;
  int get frameID => _frameID;

  String? _compositeData;
  String? get compositeData => _compositeData;

  String? _compositeRawData;
  String? get compositeRawData => _compositeRawData;

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
      String? compositeData,
      String? compositeRawData}) {
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
    _compositeData = compositeData;
    _compositeRawData = compositeRawData;
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
    var compositeData = json['compositeData'] as String?;
    var compositeRawData = json['compositeRawData'] as String?;
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
        compositeData: compositeData,
        compositeRawData: compositeRawData);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'symbology': symbology.jsonValue,
      'data': data,
      'rawData': rawData,
      'addOnData': addOnData,
      'encodingRanges': encodingRanges.map((e) => e.toMap()).toList(),
      'location': location.toMap(),
      'isGS1DataCarrier': isGS1DataCarrier,
      'compositeFlag': compositeFlag.jsonValue,
      'isColorInverted': isColorInverted,
      'symbolCount': symbolCount,
      'frameId': frameID,
      'compositeData': compositeData,
      'compositeRawData': compositeRawData
    };
  }
}

class LocalizedOnlyBarcode {
  Quadrilateral _location;
  Quadrilateral get location => _location;

  int _frameId;
  int get frameId => _frameId;

  LocalizedOnlyBarcode._(this._location, this._frameId);

  LocalizedOnlyBarcode.fromJSON(Map<String, dynamic> json)
      : this._(Quadrilateral.fromJSON(json['location']), (json['frameId'] as num).toInt());
}
