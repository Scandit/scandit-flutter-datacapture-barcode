/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

enum ArucoDictionaryPreset {
  arucoDictionaryPreset_5X5_50('5X5_50'),
  arucoDictionaryPreset_5X5_100('5X5_100'),
  arucoDictionaryPreset_5X5_250('5X5_250'),
  arucoDictionaryPreset_5X5_1000('5X5_1000'),
  arucoDictionaryPreset_5X5_1023('5X5_1023'),
  arucoDictionaryPreset_4X4_250('4X4_250'),
  arucoDictionaryPreset_6X6_250('6X6_250');

  const ArucoDictionaryPreset(this._name);

  @override
  String toString() => _name;

  final String _name;
}
