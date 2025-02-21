import 'package:flutter/widgets.dart';
import 'barcode_batch_advanced_overlay_container.dart';

abstract class BarcodeBatchAdvancedOverlayWidget extends StatefulWidget {
  final double? width;
  final double? height;

  const BarcodeBatchAdvancedOverlayWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  BarcodeBatchAdvancedOverlayWidgetState createState();
}

abstract class BarcodeBatchAdvancedOverlayWidgetState<T extends BarcodeBatchAdvancedOverlayWidget> extends State<T> {
  @override
  BarcodeBatchAdvancedOverlayContainer build(BuildContext context);
}
