/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../scandit_flutter_datacapture_barcode.dart';

enum Symbology {
  ean13Upca('ean13Upca'),
  upce('upce'),
  ean8('ean8'),
  code39('code39'),
  code93('code93'),
  code128('code128'),
  code11('code11'),
  code25('code25'),
  codabar('codabar'),
  interleavedTwoOfFive('interleavedTwoOfFive'),
  msiPlessey('msiPlessey'),
  qr('qr'),
  dataMatrix('dataMatrix'),
  aztec('aztec'),
  maxiCode('maxicode'),
  dotCode('dotcode'),
  kix('kix'),
  rm4scc('rm4scc'),
  gs1Databar('databar'),
  gs1DatabarExpanded('databarExpanded'),
  gs1DatabarLimited('databarLimited'),
  pdf417('pdf417'),
  microPdf417('microPdf417'),
  microQr('microQr'),
  code32('code32'),
  lapa4sc('lapa4sc'),
  iataTwoOfFive('iata2of5'),
  matrixTwoOfFive('matrix2of5'),
  uspsIntelligentMail('uspsIntelligentMail'),
  arUco('aruco');

  const Symbology(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SymbologySerializer on Symbology {
  static Symbology fromJSON(String jsonValue) {
    return Symbology.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

class EncodingRange implements Serializable {
  String _ianaName;
  String get ianaName => _ianaName;

  int _startIndex;
  int get startIndex => _startIndex;

  int _endIndex;
  int get endIndex => _endIndex;

  EncodingRange(this._ianaName, this._startIndex, this._endIndex);

  EncodingRange.fromJSON(Map<String, dynamic> json)
      : this(json['ianaName'] as String, (json['startIndex'] as num).toInt(), (json['endIndex'] as num).toInt());

  @override
  Map<String, dynamic> toMap() {
    return {'ianaName': _ianaName, 'startIndex': _startIndex, 'endIndex': _endIndex};
  }
}

// ignore: avoid_classes_with_only_static_members
class Ean13UpcaClassification {
  static bool isUpca(Barcode barcode) {
    if (barcode.symbology != Symbology.ean13Upca) {
      return false;
    }

    return barcode.data?.length == 12 || (barcode.data?.length == 13 && barcode.data?[0] == '0');
  }

  static bool isEan13(Barcode barcode) {
    if (barcode.symbology != Symbology.ean13Upca) {
      return false;
    }

    return barcode.data?.length == 13 && barcode.data?[0] != '0';
  }
}
