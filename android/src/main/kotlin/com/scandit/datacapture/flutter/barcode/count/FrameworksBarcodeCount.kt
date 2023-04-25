package com.scandit.datacapture.flutter.barcode.count

import android.content.Context
import android.widget.FrameLayout
import com.scandit.datacapture.barcode.capture.BarcodeCapture
import com.scandit.datacapture.barcode.count.capture.BarcodeCount
import com.scandit.datacapture.barcode.count.capture.BarcodeCountSettings
import com.scandit.datacapture.barcode.count.capture.list.BarcodeCountCaptureList
import com.scandit.datacapture.barcode.count.capture.list.TargetBarcode
import com.scandit.datacapture.barcode.count.feedback.BarcodeCountFeedback
import com.scandit.datacapture.barcode.count.serialization.BarcodeCountDeserializer
import com.scandit.datacapture.barcode.count.serialization.BarcodeCountViewDeserializer
import com.scandit.datacapture.barcode.count.ui.view.BarcodeCountView
import com.scandit.datacapture.core.capture.DataCaptureContext
import com.scandit.datacapture.core.ui.style.Brush
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountCaptureListListener
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountListener
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountViewListener
import com.scandit.datacapture.flutter.barcode.count.listeners.ScanditFlutterBarcodeCountViewUiListener
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeCountDefaults
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeCountSettingsDefaults
import com.scandit.datacapture.flutter.barcode.data.defaults.SerializableBarcodeCountViewDefaults
import com.scandit.datacapture.flutter.core.common.Logger
import com.scandit.datacapture.flutter.core.data.defaults.SerializableCameraSettingsDefaults
import com.scandit.datacapture.flutter.core.deserializers.DataCaptureContextLifecycleObserver
import org.json.JSONArray
import org.json.JSONObject

class FrameworksBarcodeCount(
    private val context: Context,
    private val captureListListener: ScanditFlutterBarcodeCountCaptureListListener,
    private val barcodeCountListener: ScanditFlutterBarcodeCountListener,
    private val viewListener: ScanditFlutterBarcodeCountViewListener,
    private val viewUiListener: ScanditFlutterBarcodeCountViewUiListener,
    private val sessionHolder: ScanditFlutterBarcodeCountSessionHolder,
    private val barcodeCountDeserializer: BarcodeCountDeserializer =
        BarcodeCountDeserializer(),
    private val barcodeCountViewDeserializer: BarcodeCountViewDeserializer =
        BarcodeCountViewDeserializer()
) : DataCaptureContextLifecycleObserver.Callbacks {

    private var dataCaptureContext: DataCaptureContext? = null

    private var barcodeCountView: BarcodeCountView? = null

    private var barcodeCount: BarcodeCount? = null
        private set(value) {
            field?.removeListener(barcodeCountListener)
            field = value?.also { it.addListener(barcodeCountListener) }
        }

    override fun onDataCaptureContextUpdated(dataCaptureContext: DataCaptureContext?) {
        this.dataCaptureContext = dataCaptureContext
    }

    fun init() {
        DataCaptureContextLifecycleObserver.callbacks += this
    }

    fun dispose() {
        DataCaptureContextLifecycleObserver.callbacks -= this
        disposeBarcodeCountView()
    }

    fun addViewFromJson(container: FrameLayout, viewJson: String) {
        val dcContext = dataCaptureContext
        if (dcContext == null) {
            Logger.error(
                "Error during the barcode count view deserialization. " +
                    "Error: The DataCaptureView has not been initialized yet."
            )
            return
        }
        val json = JSONObject(viewJson)
        if (!json.has("BarcodeCount")) {
            Logger.error(
                "Error during the barcode count view deserialization. " +
                    "Error: Json string doesn't contain `BarcodeCount`"
            )
            return
        }

        val barcodeCountModeJson = json["BarcodeCount"].toString()

        val mode: BarcodeCount
        try {
            mode = barcodeCountDeserializer.modeFromJson(dcContext, barcodeCountModeJson)
        } catch (error: Exception) {
            Logger.error(
                "Error during the barcode count view deserialization." +
                    " Error: ${error.message ?: "unknown"}"
            )
            return
        }
        barcodeCount = mode

        if (!json.has("View")) {
            Logger.error(
                "Error during the barcode count view deserialization. " +
                    "Error: Json string doesn't contain `BarcodeCountView`"
            )
            return
        }
        val barcodeCountViewJson = json["View"].toString()

        try {
            barcodeCountView = barcodeCountViewDeserializer.viewFromJson(
                context,
                dcContext,
                mode,
                barcodeCountViewJson
            ).also {
                it.uiListener = viewUiListener
                it.listener = viewListener

                container.addView(it)
            }
        } catch (error: Exception) {
            Logger.error(
                "Error during the barcode count view deserialization. " +
                    "Error: ${error.message ?: "unknown"}"
            )
        }
    }

    fun updateBarcodeCountView(viewJson: String) {
        val bcView = barcodeCountView ?: return

        barcodeCountViewDeserializer.updateViewFromJson(bcView, viewJson)
    }

    fun updateBarcodeCount(modeJson: String) {
        val mode = barcodeCount ?: return
        barcodeCount = barcodeCountDeserializer.updateModeFromJson(mode, modeJson)
        val json = JSONObject(modeJson)
        if(json.has("enabled")) {
            barcodeCount?.isEnabled = json.getBoolean("enabled")
        }
    }

    fun addBarcodeCountViewListener() {
        barcodeCountView?.listener = viewListener
    }

    fun removeBarcodeCountViewListener() {
        barcodeCountView?.listener = null
    }

    fun addBarcodeCountViewUiListener() {
        barcodeCountView?.uiListener = viewUiListener
    }

    fun removeBarcodeCountViewUiListener() {
        barcodeCountView?.uiListener = null
    }

    fun clearHighlights() {
        barcodeCountView?.clearHighlights()
    }

    fun finishBrushForRecognizedBarcodeEvent(brush: Brush) {
        viewListener.finishBrushForRecognizedBarcodeEvent(brush)
    }

    fun finishBrushForRecognizedBarcodeNotInListEvent(brush: Brush) {
        viewListener.finishBrushForRecognizedBarcodeNotInListEvent(brush)
    }

    fun finishBrushForUnrecognizedBarcodeEvent(brush: Brush) {
        viewListener.finishBrushForUnrecognizedBarcodeEvent(brush)
    }

    fun getDefaults(): String {
        val settings = BarcodeCountSettings()
        val cameraSettings = BarcodeCapture.createRecommendedCameraSettings()
        val mode = BarcodeCount.forDataCaptureContext(null, settings)

        val defaults = SerializableBarcodeCountDefaults(
            recommendedCameraSettings = SerializableCameraSettingsDefaults(
                settings = cameraSettings
            ),
            barcodeCountSettings = SerializableBarcodeCountSettingsDefaults(
                settings
            ),
            barcodeCountFeedback = BarcodeCountFeedback.defaultFeedback(),
            barcodeCountView = SerializableBarcodeCountViewDefaults(
                context,
                BarcodeCountView.newInstance(context, null, mode)
            )
        )

        return defaults.toJson().toString()
    }

    fun setBarcodeCountCaptureList(barcodes: JSONArray) {
        val targetBarcodes = mutableListOf<TargetBarcode>()
        for (i in 0 until barcodes.length()) {
            val values = JSONObject(barcodes[i].toString())
            targetBarcodes.add(
                TargetBarcode.create(
                    values["data"].toString(),
                    values["quantity"].toString().toInt()
                )
            )
        }

        barcodeCount?.setBarcodeCountCaptureList(
            BarcodeCountCaptureList.create(
                captureListListener,
                targetBarcodes
            )
        )
    }

    fun resetBarcodeCountSession(frameSequenceId: Long?) {
        sessionHolder.reset(frameSequenceId)
    }

    fun finishOnScan(enabled: Boolean) {
        barcodeCountListener.finishOnScan(enabled)
    }

    fun enableBarcodeCountListener() {
        barcodeCountListener.enableListener()
    }

    fun removeBarcodeCountListener() {
        barcodeCountListener.disableListener()
    }

    fun resetBarcodeCount() {
        barcodeCount?.reset()
    }

    fun startScanningPhase() {
        barcodeCount?.startScanningPhase()
    }

    fun endScanningPhase() {
        barcodeCount?.endScanningPhase()
    }

    fun disposeBarcodeCountView() {
        barcodeCountView?.listener = null
        barcodeCountView?.uiListener = null
        barcodeCountView = null
        barcodeCount?.removeListener(barcodeCountListener)
        barcodeCount = null
    }
}
