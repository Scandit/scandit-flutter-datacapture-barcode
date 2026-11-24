/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import '../scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/src/internal/generated/schema_types.dart' show buildEncodingRange;

/// An enumeration of barcode types (symbologies) supported by the Scandit Data Capture SDK.
///
/// The availability of the symbology depends on the licensed features.
///
/// Added in version 6.7.0
enum Symbology {
  /// EAN-13/UPC-12/UPC-A 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  ean13Upca('ean13Upca'),
  /// UPC-E 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  upce('upce'),
  /// Ean8 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  ean8('ean8'),
  /// Code39 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  code39('code39'),
  /// Code93 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  code93('code93'),
  /// Code128 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  code128('code128'),
  /// Code11 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  code11('code11'),
  /// Code25 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  code25('code25'),
  /// Codabar 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  codabar('codabar'),
  /// Interleaved two of five (ITF) 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  interleavedTwoOfFive('interleavedTwoOfFive'),
  /// MSI-Plessey 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  msiPlessey('msiPlessey'),
  /// QR Code 2D barcode symbology.
  ///
  /// Added in version 6.7.0
  qr('qr'),
  /// Data Matrix 2D barcode symbology.
  ///
  /// Added in version 6.7.0
  dataMatrix('dataMatrix'),
  /// Aztec Code 2D barcode symbology.
  ///
  /// Added in version 6.7.0
  aztec('aztec'),
  /// MaxiCode 2D barcode symbology.
  ///
  /// Added in version 6.7.0
  maxiCode('maxicode'),
  /// Dot Code symbology.
  ///
  /// Added in version 6.7.0
  dotCode('dotcode'),
  /// Royal Dutch TPG Post KIX.
  ///
  /// Added in version 6.7.0
  kix('kix'),
  /// Royal Mail 4 State Customer Code (RM4SCC).
  ///
  /// Added in version 6.7.0
  royalMail4state('royal-mail-4state'),
  /// GS1 DataBar 14 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  gs1Databar('databar'),
  /// GS1 DataBar Expanded 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  gs1DatabarExpanded('databarExpanded'),
  /// GS1 DataBarLimited 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  gs1DatabarLimited('databarLimited'),
  /// PDF417 barcode symbology.
  ///
  /// Added in version 6.7.0
  pdf417('pdf417'),
  /// MicroPDF417 barcode symbology.
  ///
  /// Added in version 6.7.0
  microPdf417('microPdf417'),
  /// MicroQR Code 2D barcode symbology.
  ///
  /// Added in version 6.7.0
  microQr('microQr'),
  /// Code32 1D barcode symbology.
  ///
  /// Added in version 6.7.0
  code32('code32'),
  /// Posi LAPA Reed Solomon 4-state code postal code symbology.
  ///
  /// Added in version 6.7.0
  lapa4sc('lapa4sc'),
  /// IATA 2 of 5 barcode symbology.
  ///
  /// Added in version 6.7.0
  iataTwoOfFive('iata2of5'),
  /// Matrix 2 of 5 barcode symbology.
  ///
  /// Added in version 6.7.0
  matrixTwoOfFive('matrix2of5'),
  /// Intelligent Mail symbology.
  ///
  /// Added in version 6.7.0
  uspsIntelligentMail('uspsIntelligentMail'),
  /// ArUco symbology.
  ///
  /// Added in version 6.19.0
  arUco('aruco'),
  /// UPU-4State symbology.
  ///
  /// Added in version 6.20.0
  upu4State('upu-4state'),
  /// Australian Post symbology.
  ///
  /// Added in version 6.23.0
  australianPost('australian-post-4state'),
  /// French Post symbology.
  ///
  /// Added in version 6.24.0
  frenchPost('french-post'),
  /// Han Xin Code symbology.
  ///
  /// Added in version 8.7.0
  hanXin('hanXin');

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

/// Defines the encoding of a range of bytes.
///
/// Added in version 6.7.0
class EncodingRange implements Serializable {
  String _ianaName;
  /// Charset encoding name as defined by [IANA](http://www.iana.org/assignments/character-sets/character-sets.xhtml).
  ///
  /// Added in version 6.7.0
  String get ianaName => _ianaName;

  int _startIndex;
  /// Start index of this encoding range.
  ///
  /// Added in version 6.7.0
  int get startIndex => _startIndex;

  int _endIndex;
  /// End index (first index after the last) of this encoding range.
  ///
  /// Added in version 6.7.0
  int get endIndex => _endIndex;

  /// Constructs a new encoding range.
  ///
  /// Added in version 6.7.0
  EncodingRange(this._ianaName, this._startIndex, this._endIndex);

  EncodingRange.fromJSON(Map<String, dynamic> json)
      : this(json['ianaName'] as String, (json['startIndex'] as num).toInt(), (json['endIndex'] as num).toInt());

  @override
  Map<String, dynamic> toMap() {
    return buildEncodingRange(
      ianaName: _ianaName,
      startIndex: _startIndex,
      endIndex: _endIndex,
    );
  }
}

// ignore: avoid_classes_with_only_static_members
/// Helper class to distinguish between UPC-A and EAN13 barcodes. Normally they are both returned as an [Symbology.ean13Upca] because UPC-A codes are a subset of EAN-13 instead of an entirely separate symbology.
///
/// Added in version 6.16.1
class Ean13UpcaClassification {
  /// Returns true if barcode is UPC-A.
  ///
  /// Added in version 6.16.1
  static bool isUpca(Barcode barcode) {
    if (barcode.symbology != Symbology.ean13Upca) {
      return false;
    }

    return barcode.data?.length == 12 || (barcode.data?.length == 13 && barcode.data?[0] == '0');
  }

  /// Returns true if barcode is EAN 13.
  ///
  /// Added in version 6.16.1
  static bool isEan13(Barcode barcode) {
    if (barcode.symbology != Symbology.ean13Upca) {
      return false;
    }

    return barcode.data?.length == 13 && barcode.data?[0] != '0';
  }
}
