import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_session.dart';
import 'package:scandit_flutter_datacapture_barcode/src/spark/spark_scan_view.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class SparkScanListener {
  Future<void> didUpdateSession(SparkScan sparkScan, SparkScanSession session, Future<FrameData> getFrameData());
  Future<void> didScan(SparkScan sparkScan, SparkScanSession session, Future<FrameData> getFrameData());
}
