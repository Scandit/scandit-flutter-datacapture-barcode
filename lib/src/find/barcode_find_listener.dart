/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

import 'package:scandit_flutter_datacapture_barcode/src/find/barcode_find_item.dart';

abstract class BarcodeFindListener {
  void didStartSearch();
  void didPauseSearch(Set<BarcodeFindItem> foundItems);
  void didStopSearch(Set<BarcodeFindItem> foundItems);
}
