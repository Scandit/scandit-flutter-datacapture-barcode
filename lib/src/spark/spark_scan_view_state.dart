/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

enum SparkScanViewState {
  initial('initial'),
  idle('idle'),
  inactive('inactive'),
  active('active'),
  error('error');

  const SparkScanViewState(this._name);

  @override
  String toString() => _name;

  final String _name;
}

extension SparkScanViewStateSerializer on SparkScanViewState {
  static SparkScanViewState fromJSON(String jsonValue) {
    return SparkScanViewState.values.firstWhere((element) => element.toString() == jsonValue);
  }
}
