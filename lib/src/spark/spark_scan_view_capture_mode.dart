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
  // ignore: deprecated_member_use_from_same_package
  final SparkScanScanningPrecision _scanningPrecision;
  final SparkScanPreviewBehavior _previewBehavior;
  final String _type;

  SparkScanScanningMode._(this._type, this._scanningBehavior, this._scanningPrecision, this._previewBehavior);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "type": _type,
      "settings": {
        "scanningBehavior": _scanningBehavior.toString(),
        "scanningPrecision": _scanningPrecision.toString(),
        "previewBehavior": _previewBehavior.toString(),
      }
    };
  }
}

class SparkScanScanningModeTarget extends SparkScanScanningMode {
  @Deprecated('Replaced by the fromPreviewBehavior constructor.')
  SparkScanScanningModeTarget(SparkScanScanningBehavior scanningBehavior, SparkScanScanningPrecision scanningPrecision)
      : super._('target', scanningBehavior, scanningPrecision, SparkScanPreviewBehavior.defaultBehaviour);

  SparkScanScanningModeTarget.fromPreviewBehavior(
      SparkScanScanningBehavior scanningBehavior, SparkScanPreviewBehavior previewBehavior)
      // ignore: deprecated_member_use_from_same_package
      : super._('target', scanningBehavior, SparkScanScanningPrecision.defaultPrecision, previewBehavior);

  SparkScanScanningBehavior get scanningBehavior {
    return _scanningBehavior;
  }

  @Deprecated('Replaced by previewBehavior.')
  SparkScanScanningPrecision get scanningPrecision {
    return _scanningPrecision;
  }

  SparkScanPreviewBehavior get previewBehavior {
    return _previewBehavior;
  }
}

class SparkScanScanningModeDefault extends SparkScanScanningMode {
  @Deprecated('Replaced by the fromPreviewBehavior constructor.')
  SparkScanScanningModeDefault(SparkScanScanningBehavior scanningBehavior, SparkScanScanningPrecision scanningPrecision)
      : super._('default', scanningBehavior, scanningPrecision, SparkScanPreviewBehavior.defaultBehaviour);

  SparkScanScanningModeDefault.fromPreviewBehavior(
      SparkScanScanningBehavior scanningBehavior, SparkScanPreviewBehavior previewBehavior)
      // ignore: deprecated_member_use_from_same_package
      : super._('default', scanningBehavior, SparkScanScanningPrecision.defaultPrecision, previewBehavior);

  SparkScanScanningBehavior get scanningBehavior {
    return _scanningBehavior;
  }

  @Deprecated('Replaced by previewBehavior.')
  SparkScanScanningPrecision get scanningPrecision {
    return _scanningPrecision;
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
