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
  final SparkScanScanningPrecision _scanningPrecision;
  final String _type;

  SparkScanScanningMode._(this._type, this._scanningBehavior, this._scanningPrecision);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "type": _type,
      "settings": {"scanningBehavior": _scanningBehavior.toString(), "scanningPrecision": _scanningPrecision.toString()}
    };
  }
}

class SparkScanScanningModeTarget extends SparkScanScanningMode {
  SparkScanScanningModeTarget(SparkScanScanningBehavior scanningBehavior, SparkScanScanningPrecision scanningPrecision)
      : super._('target', scanningBehavior, scanningPrecision);

  SparkScanScanningBehavior get scanningBehavior {
    return _scanningBehavior;
  }

  SparkScanScanningPrecision get scanningPrecision {
    return _scanningPrecision;
  }
}

class SparkScanScanningModeDefault extends SparkScanScanningMode {
  SparkScanScanningModeDefault(SparkScanScanningBehavior scanningBehavior, SparkScanScanningPrecision scanningPrecision)
      : super._('default', scanningBehavior, scanningPrecision);

  SparkScanScanningBehavior get scanningBehavior {
    return _scanningBehavior;
  }

  SparkScanScanningPrecision get scanningPrecision {
    return _scanningPrecision;
  }
}

extension SparkScanScanningModeSerializer on SparkScanScanningMode {
  static SparkScanScanningMode fromJSON(Map<String, dynamic> json) {
    var scanningModeType = json['type'];
    switch (scanningModeType) {
      case 'default':
        return SparkScanScanningModeDefault(
            SparkScanScanningBehaviorDeserializer.fromJSON(json['settings']['scanningBehavior'].toString()),
            SparkScanScanningPrecisionDeserializer.fromJSON(json['settings']['scanningPrecision'].toString()));
      case 'target':
        return SparkScanScanningModeTarget(
            SparkScanScanningBehaviorDeserializer.fromJSON(json['settings']['scanningBehavior'].toString()),
            SparkScanScanningPrecisionDeserializer.fromJSON(json['settings']['scanningPrecision'].toString()));
      default:
        throw Exception("Missing SparkScanScanningMode for type '$scanningModeType'");
    }
  }
}
