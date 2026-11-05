/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2021- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

import 'barcode_selection_aimer_behavior.dart';
import 'barcode_selection_defaults.dart';
import 'barcode_selection_freeze_behaviour.dart';
import 'barcode_selection_tap_behaviour.dart';
import 'barcode_selection_strategy.dart';

/// The interface for all barcode selection types. Possible selection types are:
///
/// - [BarcodeSelectionAimerSelection]
/// - [BarcodeSelectionTapSelection]
///
/// Added in version 6.10.0
abstract class BarcodeSelectionType implements Serializable {
  final String _type;

  BarcodeSelectionType._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

/// Tap based selection, customizable via [BarcodeSelectionTapSelection.freezeBehavior] and [BarcodeSelectionTapSelection.tapBehavior].
///
/// Added in version 6.10.0
class BarcodeSelectionTapSelection extends BarcodeSelectionType {
  /// Freeze behavior to use, defaults to [BarcodeSelectionFreezeBehavior.manual]
  ///
  /// Added in version 6.10.0
  BarcodeSelectionFreezeBehavior freezeBehavior;

  /// Added in version 6.10.0
  BarcodeSelectionTapBehavior tapBehavior;

  /// Sets should freeze on double tap, defaults to true.
  ///
  /// Added in version 8.4.0
  bool shouldFreezeOnDoubleTap;

  BarcodeSelectionTapSelection._(this.freezeBehavior, this.tapBehavior, this.shouldFreezeOnDoubleTap)
      : super._('tapSelection');

  /// Creates a new [BarcodeSelectionTapSelection] instance with the specified [BarcodeSelectionFreezeBehavior] and [BarcodeSelectionTapBehavior].
  ///
  /// Added in version 6.10.0
  BarcodeSelectionTapSelection()
      : this._(
            BarcodeSelectionDefaults.barcodeSelectionTapSelectionDefaults.freezeBehavior,
            BarcodeSelectionDefaults.barcodeSelectionTapSelectionDefaults.tapBehavior,
            BarcodeSelectionDefaults.barcodeSelectionTapSelectionDefaults.shouldFreezeOnDoubleTap);

  BarcodeSelectionTapSelection.withFreezeBehaviourAndTapBehaviour(
      BarcodeSelectionFreezeBehavior freezeBehavior, BarcodeSelectionTapBehavior tapBehavior)
      : this._(freezeBehavior, tapBehavior,
            BarcodeSelectionDefaults.barcodeSelectionTapSelectionDefaults.shouldFreezeOnDoubleTap);

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'tapBehavior': tapBehavior.toString(),
      'freezeBehavior': freezeBehavior.toString(),
      'shouldFreezeOnDoubleTap': shouldFreezeOnDoubleTap,
    });
    return json;
  }
}

/// Aimer based selection, customizable via [BarcodeSelectionAimerSelection.selectionStrategy].
///
/// Added in version 6.10.0
class BarcodeSelectionAimerSelection extends BarcodeSelectionType {
  /// The selection strategy to use. Defaults to [BarcodeSelectionManualSelectionStrategy].
  ///
  /// Added in version 6.10.0
  BarcodeSelectionStrategy selectionStrategy =
      BarcodeSelectionDefaults.barcodeSelectionAimerSelectionDefaults.selectionStrategy;

  /// Aimer behavior to use. Defaults to [BarcodeSelectionAimerBehavior.repeatSelection].
  ///
  /// Added in version 8.5.0
  BarcodeSelectionAimerBehavior aimerBehavior =
      BarcodeSelectionDefaults.barcodeSelectionAimerSelectionDefaults.aimerBehavior;

  /// Creates a new [BarcodeSelectionAimerSelection] instance with the specified [BarcodeSelectionAimerBehavior].
  ///
  /// Added in version 8.5.0
  BarcodeSelectionAimerSelection() : super._('aimerSelection');

  BarcodeSelectionAimerSelection.withAimerBehavior(this.aimerBehavior) : super._('aimerSelection');

  @override
  Map<String, dynamic> toMap() {
    var json = super.toMap();
    json.addAll({
      'selectionStrategy': selectionStrategy.toMap(),
      'aimerBehavior': aimerBehavior.toString(),
    });
    return json;
  }
}

extension BarcodeSelectionTypeDeserializer on BarcodeSelectionType {
  static BarcodeSelectionType fromJSON(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'tapSelection':
        return BarcodeSelectionTapSelection._(
            BarcodeSelectionFreezeBehaviorSerializer.fromJSON(json['freezeBehavior']),
            BarcodeSelectionTapBehaviorSerializer.fromJSON(json['tapBehavior']),
            json['shouldFreezeOnDoubleTap'] as bool? ??
                BarcodeSelectionDefaults.barcodeSelectionTapSelectionDefaults.shouldFreezeOnDoubleTap);
      case 'aimerSelection':
        var aimerSelection = BarcodeSelectionAimerSelection();
        if (json.containsKey('selectionStrategy')) {
          aimerSelection.selectionStrategy = BarcodeSelectionStrategyDeserializer.fromJSON(json['selectionStrategy']);
        }
        if (json.containsKey('aimerBehavior')) {
          aimerSelection.aimerBehavior = BarcodeSelectionAimerBehavior.fromJSON(json['aimerBehavior'] as String);
        }
        return aimerSelection;
      default:
        return BarcodeSelectionTapSelection();
    }
  }
}
