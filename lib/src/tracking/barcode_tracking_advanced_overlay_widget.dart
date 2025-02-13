import 'package:flutter/widgets.dart';
import 'barcode_tracking_advanced_overlay_container.dart';

abstract class BarcodeTrackingAdvancedOverlayWidget extends StatefulWidget {
  final double? width;
  final double? height;

  BarcodeTrackingAdvancedOverlayWidget({
    Key? key,
    this.width,
    this.height,
  });

  @override
  BarcodeTrackingAdvancedOverlayWidgetState createState();
}

abstract class BarcodeTrackingAdvancedOverlayWidgetState<T extends BarcodeTrackingAdvancedOverlayWidget>
    extends State<T> {
  @override
  BarcodeTrackingAdvancedOverlayContainer build(BuildContext context);
}
