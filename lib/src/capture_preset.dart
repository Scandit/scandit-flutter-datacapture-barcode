/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

enum CapturePreset {
  transport('transport'),
  logistics('logistics'),
  retail('retail'),
  healthcare('healthcare'),
  manufacturing('manufacturing');

  const CapturePreset(this._name);

  @override
  String toString() => _name;

  final String _name;

  static CapturePreset fromJSON(String jsonValue) {
    return CapturePreset.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
