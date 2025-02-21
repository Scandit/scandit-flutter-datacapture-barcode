/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'spark_scan_view.dart';

enum SparkScanScanningBehavior {
  single('single'),
  continuous('continuous');

  const SparkScanScanningBehavior(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SparkScanScanningBehaviorDeserializer on SparkScanScanningBehavior {
  static SparkScanScanningBehavior fromJSON(String jsonValue) {
    return SparkScanScanningBehavior.values.firstWhere((element) => element.toString() == jsonValue);
  }
}

abstract class SparkScanScanningMode extends Serializable {
  final SparkScanScanningBehavior _scanningBehavior;
  final SparkScanPreviewBehavior _previewBehavior;
  final String _type;

  SparkScanScanningMode._(this._type, this._scanningBehavior, this._previewBehavior);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "type": _type,
      "settings": {
        "scanningBehavior": _scanningBehavior.toString(),
        "previewBehavior": _previewBehavior.toString(),
      }
    };
  }
}

class SparkScanScanningModeTarget extends SparkScanScanningMode {
  SparkScanScanningModeTarget.fromPreviewBehavior(
      SparkScanScanningBehavior scanningBehavior, SparkScanPreviewBehavior previewBehavior)
      : super._('target', scanningBehavior, previewBehavior);

  SparkScanScanningBehavior get scanningBehavior {
    return _scanningBehavior;
  }

  SparkScanPreviewBehavior get previewBehavior {
    return _previewBehavior;
  }
}

class SparkScanScanningModeDefault extends SparkScanScanningMode {
  SparkScanScanningModeDefault.fromPreviewBehavior(
      SparkScanScanningBehavior scanningBehavior, SparkScanPreviewBehavior previewBehavior)
      : super._('default', scanningBehavior, previewBehavior);

  SparkScanScanningBehavior get scanningBehavior {
    return _scanningBehavior;
  }

  SparkScanPreviewBehavior get previewBehavior {
    return _previewBehavior;
  }
}

extension SparkScanScanningModeSerializer on SparkScanScanningMode {
  static SparkScanScanningMode fromJSON(Map<String, dynamic> json) {
    var scanningModeType = json['type'];
    switch (scanningModeType) {
      case 'default':
        return SparkScanScanningModeDefault.fromPreviewBehavior(
            SparkScanScanningBehaviorDeserializer.fromJSON(json['settings']['scanningBehavior'].toString()),
            SparkScanPreviewBehaviorDeserializer.fromJSON(json['settings']['previewBehavior'].toString()));
      case 'target':
        return SparkScanScanningModeTarget.fromPreviewBehavior(
            SparkScanScanningBehaviorDeserializer.fromJSON(json['settings']['scanningBehavior'].toString()),
            SparkScanPreviewBehaviorDeserializer.fromJSON(json['settings']['previewBehavior'].toString()));
      default:
        throw Exception("Missing SparkScanScanningMode for type '$scanningModeType'");
    }
  }
}
