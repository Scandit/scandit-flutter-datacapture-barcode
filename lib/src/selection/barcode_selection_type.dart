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

abstract class BarcodeSelectionType implements Serializable {
  final String _type;

  BarcodeSelectionType._(this._type);

  @override
  Map<String, dynamic> toMap() {
    return {'type': _type};
  }
}

class BarcodeSelectionTapSelection extends BarcodeSelectionType {
  BarcodeSelectionFreezeBehavior freezeBehavior;

  BarcodeSelectionTapBehavior tapBehavior;

  bool shouldFreezeOnDoubleTap;

  BarcodeSelectionTapSelection._(this.freezeBehavior, this.tapBehavior, this.shouldFreezeOnDoubleTap)
      : super._('tapSelection');

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

class BarcodeSelectionAimerSelection extends BarcodeSelectionType {
  BarcodeSelectionStrategy selectionStrategy =
      BarcodeSelectionDefaults.barcodeSelectionAimerSelectionDefaults.selectionStrategy;

  BarcodeSelectionAimerBehavior aimerBehavior =
      BarcodeSelectionDefaults.barcodeSelectionAimerSelectionDefaults.aimerBehavior;

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
