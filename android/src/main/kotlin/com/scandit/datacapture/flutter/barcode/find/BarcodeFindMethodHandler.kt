/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2023- Scandit AG. All rights reserved.
 */

package com.scandit.datacapture.flutter.barcode.find

import com.scandit.datacapture.flutter.core.utils.FlutterResult
import com.scandit.datacapture.frameworks.barcode.find.BarcodeFindModule
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

class BarcodeFindMethodHandler(
    private val barcodeFindModule: BarcodeFindModule
) : MethodChannel.MethodCallHandler {
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) =
        when (call.method) {
            METHOD_GET_DEFAULTS ->
                result.success(JSONObject(barcodeFindModule.getDefaults()).toString())

            METHOD_UPDATE_VIEW ->
                barcodeFindModule.updateBarcodeFindView(
                    call.arguments as String,
                    FlutterResult(result)
                )

            METHOD_UPDATE_MODE ->
                barcodeFindModule.updateBarcodeFindMode(
                    call.arguments as String,
                    FlutterResult(result)
                )

            METHOD_REGISTER_BF_LISTENER ->
                barcodeFindModule.addBarcodeFindListener(FlutterResult(result))

            METHOD_UNREGISTER_BF_LISTENER ->
                barcodeFindModule.removeBarcodeFindListener(FlutterResult(result))

            METHOD_REGISTER_BF_VIEW_LISTENER ->
                barcodeFindModule.addBarcodeFindViewListener(FlutterResult(result))

            METHOD_UNREGISTER_BF_VIEW_LISTENER ->
                barcodeFindModule.removeBarcodeFindViewListener(FlutterResult(result))

            METHOD_BF_VIEW_ON_PAUSE -> barcodeFindModule.viewOnPause(FlutterResult(result))

            METHOD_BF_VIEW_ON_RESUME -> barcodeFindModule.viewOnResume(FlutterResult(result))

            METHOD_BF_SET_ITEMS_LIST ->
                barcodeFindModule.setItemList(call.arguments as String, FlutterResult(result))

            METHOD_BF_VIEW_STOP_SEARCHING ->
                barcodeFindModule.viewStopSearching(FlutterResult(result))

            METHOD_BF_VIEW_START_SEARCHING ->
                barcodeFindModule.viewStartSearching(FlutterResult(result))

            METHOD_BF_VIEW_PAUSE_SEARCHING ->
                barcodeFindModule.viewPauseSearching(FlutterResult(result))

            METHOD_BF_START -> barcodeFindModule.modeStart(FlutterResult(result))
            METHOD_BF_PAUSE -> barcodeFindModule.modePause(FlutterResult(result))
            METHOD_BF_STOP -> barcodeFindModule.modeStop(FlutterResult(result))

            METHOD_SET_MODE_ENABLED_STATE -> barcodeFindModule.setModeEnabled(
                call.arguments as Boolean
            )

            else -> throw IllegalArgumentException("Nothing implemented for ${call.method}")
        }

    companion object {
        private const val METHOD_GET_DEFAULTS = "getBarcodeFindDefaults"
        private const val METHOD_UPDATE_VIEW = "updateFindView"
        private const val METHOD_UPDATE_MODE = "updateFindMode"
        private const val METHOD_REGISTER_BF_LISTENER = "registerBarcodeFindListener"
        private const val METHOD_UNREGISTER_BF_LISTENER = "unregisterBarcodeFindListener"
        private const val METHOD_REGISTER_BF_VIEW_LISTENER = "registerBarcodeFindViewListener"
        private const val METHOD_UNREGISTER_BF_VIEW_LISTENER = "unregisterBarcodeFindViewListener"
        private const val METHOD_BF_VIEW_ON_PAUSE = "barcodeFindViewOnPause"
        private const val METHOD_BF_VIEW_ON_RESUME = "barcodeFindViewOnResume"
        private const val METHOD_BF_SET_ITEMS_LIST = "barcodeFindSetItemList"
        private const val METHOD_BF_VIEW_STOP_SEARCHING = "barcodeFindViewStopSearching"
        private const val METHOD_BF_VIEW_START_SEARCHING = "barcodeFindViewStartSearching"
        private const val METHOD_BF_VIEW_PAUSE_SEARCHING = "barcodeFindViewPauseSearching"
        private const val METHOD_BF_START = "barcodeFindModeStart"
        private const val METHOD_BF_PAUSE = "barcodeFindModePause"
        private const val METHOD_BF_STOP = "barcodeFindModeStop"
        private const val METHOD_SET_MODE_ENABLED_STATE = "setModeEnabledState"

        const val EVENT_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.find/event_channel"

        const val METHOD_CHANNEL_NAME =
            "com.scandit.datacapture.barcode.find/method_channel"
    }
}
