/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:flutter/widgets.dart';

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

abstract class BarcodePickViewHighlightStyleCustomViewWidget extends StatefulWidget {
  final double? width;
  final double? height;

  const BarcodePickViewHighlightStyleCustomViewWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  BarcodePickViewHighlightStyleCustomViewState createState();
}

abstract class BarcodePickViewHighlightStyleCustomViewState<T extends BarcodePickViewHighlightStyleCustomViewWidget>
    extends State<T> {
  @override
  BarcodePickViewHighlightStyleCustomViewContainer build(BuildContext context);
}
