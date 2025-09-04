/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_item.dart';

abstract class BarcodeFindViewUiListener {
  void didTapFinishButton(Set<BarcodeFindItem> foundItems);
}
