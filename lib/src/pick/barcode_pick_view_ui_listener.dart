/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/pick/barcode_pick_view.dart';

abstract class BarcodePickViewUiListener {
  void didTapFinishButton(BarcodePickView view);
}
