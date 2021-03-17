/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;

extension WidgetToBase64Converter on Widget {
  Future<String> get base64String => _createImageFromWidget(this);

  /// Creates an image from the given widget by first spinning up a element and render tree,
  /// and then creating an image via a [RepaintBoundary].
  Future<String> _createImageFromWidget(Widget widget) async {
    final repaintBoundary = RenderRepaintBoundary();

    var logicalSize = ui.window.physicalSize / ui.window.devicePixelRatio;

    final renderView = RenderView(
      window: null,
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: logicalSize,
        devicePixelRatio: ui.window.devicePixelRatio,
      ),
    );

    final pipelineOwner = PipelineOwner();
    final buildOwner = BuildOwner();

    pipelineOwner.rootNode = renderView;
    renderView.prepareInitialFrame();

    var renderObjectToWidgetAdapter = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: widget,
    );

    var previousErrorHandler = FlutterError.onError;

    dynamic error;

    FlutterError.onError = (details) {
      error = details.exception;
    };

    // attachToRenderTree internally throws an exception in case of not valid widget
    // the only way to catch this is to add a global error handler. This is done
    // the lines above. When it catches an error it will just throw it as
    // ArgumentError
    final rootElement = renderObjectToWidgetAdapter.attachToRenderTree(buildOwner);

    FlutterError.onError = previousErrorHandler;

    if (error != null) return throw ArgumentError(error);

    buildOwner.buildScope(rootElement);

    await Future.delayed(Duration(milliseconds: 20));

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();

    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: ui.window.devicePixelRatio);

    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    var imageBytes = byteData.buffer.asUint8List();
    return base64Encode(imageBytes);
  }
}
