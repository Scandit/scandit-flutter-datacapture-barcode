/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2024- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';
import 'barcode_batch_advanced_overlay_container.dart';

/// A widget that needs to be used as a base of the widget you want to show for a [TrackedBarcode] through a [BarcodeBatchAdvancedOverlay].
///
/// Added in version 7.0.0
abstract class BarcodeBatchAdvancedOverlayWidget extends StatefulWidget {
  /// The width of the widget. Refer to the [Container](https://api.flutter.dev/flutter/widgets/Container-class.html) class to understand this property.
  ///
  /// Added in version 7.0.0
  final double? width;
  /// The height of the widget. Refer to the [Container](https://api.flutter.dev/flutter/widgets/Container-class.html) class to understand this property.
  ///
  /// Added in version 7.0.0
  final double? height;

  const BarcodeBatchAdvancedOverlayWidget({
    super.key,
    this.width,
    this.height,
  });

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 7.0.0
  @override
  BarcodeBatchAdvancedOverlayWidgetState createState();
}

/// The state of the [BarcodeBatchAdvancedOverlayWidget].
///
/// Added in version 7.0.0
abstract class BarcodeBatchAdvancedOverlayWidgetState<T extends BarcodeBatchAdvancedOverlayWidget> extends State<T> {
  /// See [build](https://api.flutter.dev/flutter/widgets/State/build.html) for more details.
  ///
  /// Added in version 7.0.0
  @override
  BarcodeBatchAdvancedOverlayContainer build(BuildContext context);
}
