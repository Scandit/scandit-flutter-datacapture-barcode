/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_item.dart';

/// Added in version 6.22.0
abstract class BarcodeFindViewUiListener {
  /// Callback method that can be used to define an action that should be performed when the finish button is tapped from the view. The foundItems parameter contains all the items found since the start of the searching process. Called from the main thread.
  ///
  /// Added in version 6.22.0
  void didTapFinishButton(Set<BarcodeFindItem> foundItems);
}
