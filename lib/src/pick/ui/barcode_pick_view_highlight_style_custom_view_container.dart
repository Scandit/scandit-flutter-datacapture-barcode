/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';

/// The root container of the [BarcodePickViewHighlightStyleCustomViewWidget].
///
/// Added in version 7.3.0
class BarcodePickViewHighlightStyleCustomViewContainer extends Container {
  BarcodePickViewHighlightStyleCustomViewContainer({
    super.key,
    super.alignment,
    super.padding,
    super.color,
    super.decoration,
    super.foregroundDecoration,
    super.width,
    super.height,
    super.constraints,
    super.margin,
    super.transform,
    super.transformAlignment,
    super.child,
    super.clipBehavior,
  });
}

/// A base widget that allows you to create custom visual overlays displayed on top of barcodes during the picking process. Used in conjunction with BarcodePickViewHighlightStyleCustomView ([CustomView]) to customize how barcodes are highlighted.
///
/// Added in version 7.3.0
abstract class BarcodePickViewHighlightStyleCustomViewWidget extends StatefulWidget {
  /// The width of the widget. Refer to the [Container](https://api.flutter.dev/flutter/widgets/Container-class.html) class to understand this property.
  ///
  /// Added in version 7.3.0
  final double? width;
  /// The height of the widget. Refer to the [Container](https://api.flutter.dev/flutter/widgets/Container-class.html) class to understand this property.
  ///
  /// Added in version 7.3.0
  final double? height;

  const BarcodePickViewHighlightStyleCustomViewWidget({
    super.key,
    this.width,
    this.height,
  });

  /// Implemented from [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html). Called by the Flutter framework.
  ///
  /// Added in version 7.3.0
  @override
  BarcodePickViewHighlightStyleCustomViewState createState();
}

/// The state of the [BarcodePickViewHighlightStyleCustomViewWidget].
///
/// Added in version 7.3.0
abstract class BarcodePickViewHighlightStyleCustomViewState<T extends BarcodePickViewHighlightStyleCustomViewWidget>
    extends State<T> {
  /// See [build](https://api.flutter.dev/flutter/widgets/State/build.html) for more details.
  ///
  /// Added in version 7.3.0
  @override
  BarcodePickViewHighlightStyleCustomViewContainer build(BuildContext context);
}
