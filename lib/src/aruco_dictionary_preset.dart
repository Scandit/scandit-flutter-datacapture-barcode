/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

/// Lists presets that can be used to create a [ArucoDictionary]
///
/// Added in version 6.22.0
enum ArucoDictionaryPreset {
  /// Dictionary that contains 50 markers of size 5.
  ///
  /// Added in version 6.22.0
  arucoDictionaryPreset_5X5_50('5X5_50'),
  /// Dictionary that contains 100 markers of size 5.
  ///
  /// Added in version 6.22.0
  arucoDictionaryPreset_5X5_100('5X5_100'),
  /// Dictionary that contains 250 markers of size 5.
  ///
  /// Added in version 6.22.0
  arucoDictionaryPreset_5X5_250('5X5_250'),
  /// Dictionary that contains 1000 markers of size 5.
  ///
  /// Added in version 6.22.0
  arucoDictionaryPreset_5X5_1000('5X5_1000'),
  /// Dictionary that contains 1023 markers of size 5.
  ///
  /// Added in version 6.22.0
  arucoDictionaryPreset_5X5_1023('5X5_1023'),
  /// Dictionary that contains 250 markers of size 4.
  ///
  /// Added in version 6.22.0
  arucoDictionaryPreset_4X4_250('4X4_250'),
  /// Dictionary that contains 250 markers of size 6.
  ///
  /// Added in version 6.22.0
  arucoDictionaryPreset_6X6_250('6X6_250');

  const ArucoDictionaryPreset(this._name);

  @override
  String toString() => _name;

  final String _name;
}
