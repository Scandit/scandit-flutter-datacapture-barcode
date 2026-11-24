import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

/// Listener interface for traditional SparkScan.
///
/// Added in version 6.20.0
abstract class SparkScanListener {
  /// Invoked after a frame has been processed by SparkScan and the session has been updated. In contrast to didScan(), this method is invoked, regardless whether a code was scanned or not. If codes were recognized in this frame, this method is invoked after didScan().
  ///
  /// This method is invoked from a recognition internal thread. To perform UI work, you must dispatch to the main thread first. Further recognition is blocked until this method completes. It is thus recommended to do as little work as possible in this method.
  ///
  /// [FrameData] is *null* if the camera is frozen and the selection is changed.
  ///
  /// Added in version 6.20.0
  Future<void> didUpdateSession(
      SparkScan sparkScan, SparkScanSession session, Future<FrameData> Function() getFrameData);
  /// Invoked whenever a code has been scanned. The newly scanned barcode can be retrieved from [SparkScanSession.newlyRecognizedBarcode].
  ///
  /// This method is invoked from a recognition internal thread. To perform UI work, you must dispatch to the main thread first. After receiving this callback, you will typically want to start processing the scanned barcodes. Keep in mind however, that any further recognition is blocked until this method completes. Therefore, if you need to perform a time-consuming operation, like querying a database or opening an URL encoded in the barcode data, consider switching to another thread.
  ///
  /// Sometimes, after receiving this callback, you may want to stop scanning. You can do that by disabling the SparkScan ([SparkScan.isEnabled]).
  ///
  /// [FrameData] is *null* if the camera is frozen and the selection is changed.
  ///
  /// Added in version 6.20.0
  Future<void> didScan(SparkScan sparkScan, SparkScanSession session, Future<FrameData> Function() getFrameData);
}
