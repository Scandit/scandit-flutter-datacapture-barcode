/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../scandit_flutter_datacapture_barcode.dart';

enum Symbology {
  ean13Upca,
  upce,
  ean8,
  code39,
  code93,
  code128,
  code11,
  code25,
  codabar,
  interleavedTwoOfFive,
  msiPlessey,
  qr,
  dataMatrix,
  aztec,
  maxiCode,
  dotCode,
  kix,
  rm4scc,
  gs1Databar,
  gs1DatabarExpanded,
  gs1DatabarLimited,
  pdf417,
  microPdf417,
  microQr,
  code32,
  lapa4sc,
  iataTwoOfFive,
  matrixTwoOfFive,
  uspsIntelligentMail
}

extension SymbologySerializer on Symbology {
  static Symbology fromJSON(String jsonValue) {
    switch (jsonValue) {
      case 'ean13Upca':
        return Symbology.ean13Upca;
      case 'upce':
        return Symbology.upce;
      case 'ean8':
        return Symbology.ean8;
      case 'code39':
        return Symbology.code39;
      case 'code93':
        return Symbology.code93;
      case 'code128':
        return Symbology.code128;
      case 'code11':
        return Symbology.code11;
      case 'code25':
        return Symbology.code25;
      case 'codabar':
        return Symbology.codabar;
      case 'interleavedTwoOfFive':
        return Symbology.interleavedTwoOfFive;
      case 'msiPlessey':
        return Symbology.msiPlessey;
      case 'qr':
        return Symbology.qr;
      case 'dataMatrix':
        return Symbology.dataMatrix;
      case 'aztec':
        return Symbology.aztec;
      case 'maxicode':
        return Symbology.maxiCode;
      case 'dotcode':
        return Symbology.dotCode;
      case 'kix':
        return Symbology.kix;
      case 'rm4scc':
        return Symbology.rm4scc;
      case 'databar':
        return Symbology.gs1Databar;
      case 'databarExpanded':
        return Symbology.gs1DatabarExpanded;
      case 'databarLimited':
        return Symbology.gs1DatabarLimited;
      case 'pdf417':
        return Symbology.pdf417;
      case 'microPdf417':
        return Symbology.microPdf417;
      case 'microQr':
        return Symbology.microQr;
      case 'code32':
        return Symbology.code32;
      case 'lapa4sc':
        return Symbology.lapa4sc;
      case 'iata2of5':
        return Symbology.iataTwoOfFive;
      case 'matrix2of5':
        return Symbology.matrixTwoOfFive;
      case 'uspsIntelligentMail':
        return Symbology.uspsIntelligentMail;
      default:
        throw Exception("Missing Symbology for name '$jsonValue'");
    }
  }

  String get jsonValue => _jsonValue();

  String _jsonValue() {
    switch (this) {
      case Symbology.ean13Upca:
        return 'ean13Upca';
      case Symbology.upce:
        return 'upce';
      case Symbology.ean8:
        return 'ean8';
      case Symbology.code39:
        return 'code39';
      case Symbology.code93:
        return 'code93';
      case Symbology.code128:
        return 'code128';
      case Symbology.code11:
        return 'code11';
      case Symbology.code25:
        return 'code25';
      case Symbology.codabar:
        return 'codabar';
      case Symbology.interleavedTwoOfFive:
        return 'interleavedTwoOfFive';
      case Symbology.msiPlessey:
        return 'msiPlessey';
      case Symbology.qr:
        return 'qr';
      case Symbology.dataMatrix:
        return 'dataMatrix';
      case Symbology.aztec:
        return 'aztec';
      case Symbology.maxiCode:
        return 'maxicode';
      case Symbology.dotCode:
        return 'dotcode';
      case Symbology.kix:
        return 'kix';
      case Symbology.rm4scc:
        return 'rm4scc';
      case Symbology.gs1Databar:
        return 'databar';
      case Symbology.gs1DatabarExpanded:
        return 'databarExpanded';
      case Symbology.gs1DatabarLimited:
        return 'databarLimited';
      case Symbology.pdf417:
        return 'pdf417';
      case Symbology.microPdf417:
        return 'microPdf417';
      case Symbology.microQr:
        return 'microQr';
      case Symbology.code32:
        return 'code32';
      case Symbology.lapa4sc:
        return 'lapa4sc';
      case Symbology.iataTwoOfFive:
        return 'iata2of5';
      case Symbology.matrixTwoOfFive:
        return 'matrix2of5';
      case Symbology.uspsIntelligentMail:
        return 'uspsIntelligentMail';
      default:
        throw Exception("Missing name for enum '$this'");
    }
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
