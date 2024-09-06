import 'dart:developer';

import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:flutter/widgets.dart' as w;

class BarcodeTrackingAdvancedOverlayContainer extends Container {
  BarcodeTrackingAdvancedOverlayContainer({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Widget? child,
    Clip clipBehavior = Clip.none,
  }) : super(
            key: key,
            alignment: alignment,
            padding: padding,
            color: color,
            decoration: decoration,
            foregroundDecoration: foregroundDecoration,
            width: width,
            height: height,
            constraints: constraints,
            margin: margin,
            transform: transform,
            transformAlignment: transformAlignment,
            child: child,
            clipBehavior: clipBehavior);

  @override
  Widget build(BuildContext context) {
    final containerChild = child;
    if (containerChild == null) return super.build(context);

    final filteredChild = _hideImages(containerChild);

    return Container(
      key: key,
      alignment: alignment,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      padding: padding,
      constraints: constraints,
      child: filteredChild,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
    );
  }

  Widget _hideImages(Widget child) {
    if (child is Image) {
      log("The advanced overlay no longer supports rendering any kind of images. For further details about this backwards incompatible change, contact support@scandit.com.");
      return const SizedBox.shrink();
    } else if (child is SingleChildRenderObjectWidget) {
      return _rebuildSingleChildRenderObjectWidget(child);
    } else if (child is MultiChildRenderObjectWidget) {
      return _rebuildMultiChildRenderObjectWidget(child);
    } else if (child is Expanded) {
      return _rebuildExpandedWithFilteredChild(child);
    } else if (child is Container) {
      return _rebuildContainerWithFilteredChild(child);
    } else if (child is Directionality) {
      return _rebuildDirectionalityChild(child);
    } else if (child is ListView) {
      return _rebuildListViewChildren(child);
    } else if (child is Table) {
      return _rebuildTableWithFilteredChildren(child);
    } else if (child is w.Text) {
      return child;
    } else if (child is RichText) {
      return child;
    } else if (child is Spacer) {
      return child;
    } else if (child is m.Divider) {
      return child;
    } else if (child is w.TextBox) {
      return child;
    } else if (child is Icon) {
      log("The advanced overlay no longer supports rendering any kind of images. For further details about this backwards incompatible change, contact support@scandit.com.");
      return const SizedBox.shrink();
    }
    return Text(
      "Unsupport ${child.runtimeType.toString()} widget used in the overlay.",
      textDirection: TextDirection.ltr,
    );
  }

  Widget _rebuildSingleChildRenderObjectWidget(SingleChildRenderObjectWidget widget) {
    if (widget is Padding) {
      return _rebuildPaddingWithFilteredChild(widget);
    } else if (widget is Align) {
      return _rebuildAlignWithFilteredChild(widget);
    } else if (widget is Center) {
      return _rebuildCenterWithFilteredChild(widget);
    } else if (widget is SizedBox) {
      return _rebuildSizedBoxWithFilteredChild(widget);
    } else if (widget is FittedBox) {
      return _rebuildFittedBoxWithFilteredChild(widget);
    } else if (widget is FractionallySizedBox) {
      return _rebuildFractionallySizedBoxWithFilteredChild(widget);
    } else if (widget is DecoratedBox) {
      return _rebuildDecoratedBoxWithFilteredChild(widget);
    } else if (widget is Transform) {
      return _rebuildTransformWithFilteredChild(widget);
    } else if (widget is CustomSingleChildLayout) {
      return _rebuildCustomSingleChildLayoutWithFilteredChild(widget);
    } else if (widget is BackdropFilter) {
      return _rebuildBackdropFilterWithFilteredChild(widget);
    } else if (widget is ClipRect) {
      return _rebuildClipRectWithFilteredChild(widget);
    } else if (widget is ClipRRect) {
      return _rebuildClipRRectWithFilteredChild(widget);
    } else if (widget is ClipOval) {
      return _rebuildClipOvalWithFilteredChild(widget);
    } else if (widget is ConstrainedBox) {
      return _rebuildConstrainedBoxWithFilteredChild(widget);
    } else if (widget is RepaintBoundary) {
      return _rebuildRepaintBoundaryWithFilteredChild(widget);
    }
    return Text("Unsupported ${widget.runtimeType.toString()} widget used in the overlay.");
  }

  Widget _rebuildMultiChildRenderObjectWidget(MultiChildRenderObjectWidget widget) {
    if (widget is Column) {
      return _rebuildColumnWithFilteredChildren(widget);
    } else if (widget is Row) {
      return _rebuildRowWithFilteredChildren(widget);
    } else if (widget is Stack) {
      return _rebuildStackWithFilteredChildren(widget);
    } else if (widget is ListBody) {
      return _rebuildListBodyWithFilteredChildren(widget);
    } else if (widget is Wrap) {
      return _rebuildWrapWithFilteredChildren(widget);
    } else if (widget is CustomMultiChildLayout) {
      return _rebuildCustomMultiChildLayoutWithFilteredChildren(widget);
    } else if (widget is Flow) {
      return _rebuildFlowWithFilteredChildren(widget);
    } else if (widget is Flex) {
      return _rebuildFlexWithFilteredChildren(widget);
    }
    return Text(
      "Unsupported ${widget.runtimeType.toString()} widget used in the overlay.",
      textDirection: TextDirection.ltr,
    );
  }

  // Rebuild Column with filtered children
  Widget _rebuildColumnWithFilteredChildren(Column widget) {
    return Column(
      key: widget.key,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: widget.children.map(_hideImages).toList(),
      textBaseline: widget.textBaseline,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
    );
  }

  Widget _rebuildRowWithFilteredChildren(Row widget) {
    return Row(
      key: widget.key,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      children: widget.children.map(_hideImages).toList(),
      textBaseline: widget.textBaseline,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
    );
  }

  Widget _rebuildStackWithFilteredChildren(Stack widget) {
    return Stack(
      key: widget.key,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      fit: widget.fit,
      clipBehavior: widget.clipBehavior,
      children: widget.children.map(_hideImages).toList(),
    );
  }

  Widget _rebuildListBodyWithFilteredChildren(ListBody widget) {
    return ListBody(
      key: widget.key,
      mainAxis: widget.mainAxis,
      reverse: widget.reverse,
      children: widget.children.map(_hideImages).toList(),
    );
  }

  Widget _rebuildWrapWithFilteredChildren(Wrap widget) {
    return Wrap(
      key: widget.key,
      direction: widget.direction,
      alignment: widget.alignment,
      spacing: widget.spacing,
      runAlignment: widget.runAlignment,
      runSpacing: widget.runSpacing,
      crossAxisAlignment: widget.crossAxisAlignment,
      textDirection: widget.textDirection,
      verticalDirection: widget.verticalDirection,
      clipBehavior: widget.clipBehavior,
      children: widget.children.map(_hideImages).toList(),
    );
  }

  Widget _rebuildTableWithFilteredChildren(Table widget) {
    return Table(
      key: widget.key,
      children: widget.children.map((row) {
        return TableRow(
          key: row.key,
          decoration: row.decoration,
          children: row.children.map(_hideImages).toList(),
        );
      }).toList(),
      border: widget.border,
      columnWidths: widget.columnWidths,
      defaultColumnWidth: widget.defaultColumnWidth,
      textBaseline: widget.textBaseline,
      defaultVerticalAlignment: widget.defaultVerticalAlignment,
      textDirection: widget.textDirection,
    );
  }

  Widget _rebuildCustomMultiChildLayoutWithFilteredChildren(CustomMultiChildLayout widget) {
    return CustomMultiChildLayout(
      key: widget.key,
      delegate: widget.delegate,
      children: widget.children.map(_hideImages).toList(),
    );
  }

  Widget _rebuildFlowWithFilteredChildren(Flow widget) {
    return Flow(
      key: widget.key,
      delegate: widget.delegate,
      clipBehavior: widget.clipBehavior,
      children: widget.children.map(_hideImages).toList(),
    );
  }

  Widget _rebuildFlexWithFilteredChildren(Flex widget) {
    return Flex(
      key: widget.key,
      direction: widget.direction,
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisSize: widget.mainAxisSize,
      verticalDirection: widget.verticalDirection,
      textDirection: widget.textDirection,
      clipBehavior: widget.clipBehavior,
      textBaseline: widget.textBaseline,
      children: widget.children.map(_hideImages).toList(),
    );
  }

  Widget _rebuildContainerWithFilteredChild(Container widget) {
    final containerChild = widget.child;
    if (containerChild == null) return widget;

    return Container(
      key: widget.key,
      alignment: widget.alignment,
      color: widget.color,
      decoration: widget.decoration,
      foregroundDecoration: widget.foregroundDecoration,
      padding: widget.padding,
      constraints: widget.constraints,
      child: _hideImages(containerChild),
      margin: widget.margin,
      transform: widget.transform,
      transformAlignment: widget.transformAlignment,
      clipBehavior: widget.clipBehavior,
    );
  }

  Widget _rebuildPaddingWithFilteredChild(Padding widget) {
    final paddingChild = widget.child;
    if (paddingChild == null) return widget;

    return Padding(
      key: widget.key,
      padding: widget.padding,
      child: _hideImages(paddingChild),
    );
  }

  Widget _rebuildAlignWithFilteredChild(Align widget) {
    final alignChild = widget.child;
    if (alignChild == null) return widget;

    return Align(
      key: widget.key,
      alignment: widget.alignment,
      heightFactor: widget.heightFactor,
      widthFactor: widget.widthFactor,
      child: _hideImages(alignChild),
    );
  }

  Widget _rebuildCenterWithFilteredChild(Center widget) {
    final centerChild = widget.child;
    if (centerChild == null) return widget;

    return Center(
      key: widget.key,
      heightFactor: widget.heightFactor,
      widthFactor: widget.widthFactor,
      child: _hideImages(centerChild),
    );
  }

  Widget _rebuildSizedBoxWithFilteredChild(SizedBox widget) {
    final sizeBoxChild = widget.child;
    if (sizeBoxChild == null) return widget;

    return SizedBox(
      key: widget.key,
      width: widget.width,
      height: widget.height,
      child: _hideImages(sizeBoxChild),
    );
  }

  Widget _rebuildFittedBoxWithFilteredChild(FittedBox widget) {
    final fitteBoxChild = widget.child;
    if (fitteBoxChild == null) return widget;

    return FittedBox(
      key: widget.key,
      fit: widget.fit,
      alignment: widget.alignment,
      clipBehavior: widget.clipBehavior,
      child: _hideImages(fitteBoxChild),
    );
  }

  Widget _rebuildFractionallySizedBoxWithFilteredChild(FractionallySizedBox widget) {
    final fractionallySizedBoxChild = widget.child;
    if (fractionallySizedBoxChild == null) return widget;

    return FractionallySizedBox(
      key: widget.key,
      alignment: widget.alignment,
      widthFactor: widget.widthFactor,
      heightFactor: widget.heightFactor,
      child: _hideImages(fractionallySizedBoxChild),
    );
  }

  Widget _rebuildDecoratedBoxWithFilteredChild(DecoratedBox widget) {
    final decoratedBoxChild = widget.child;
    if (decoratedBoxChild == null) return widget;

    return DecoratedBox(
      key: widget.key,
      decoration: widget.decoration,
      position: widget.position,
      child: _hideImages(decoratedBoxChild),
    );
  }

  Widget _rebuildTransformWithFilteredChild(Transform widget) {
    final transformChild = widget.child;
    if (transformChild == null) return widget;

    return Transform(
      key: widget.key,
      transform: widget.transform,
      alignment: widget.alignment,
      origin: widget.origin,
      filterQuality: widget.filterQuality,
      transformHitTests: widget.transformHitTests,
      child: _hideImages(transformChild),
    );
  }

  Widget _rebuildCustomSingleChildLayoutWithFilteredChild(CustomSingleChildLayout widget) {
    final customSingleChildLayoutChild = widget.child;
    if (customSingleChildLayoutChild == null) return widget;

    return CustomSingleChildLayout(
      key: widget.key,
      delegate: widget.delegate,
      child: _hideImages(customSingleChildLayoutChild),
    );
  }

  Widget _rebuildBackdropFilterWithFilteredChild(BackdropFilter widget) {
    final backdropFilterChild = widget.child;
    if (backdropFilterChild == null) return widget;

    return BackdropFilter(
      key: widget.key,
      filter: widget.filter,
      blendMode: widget.blendMode,
      child: _hideImages(backdropFilterChild),
    );
  }

  Widget _rebuildClipRectWithFilteredChild(ClipRect widget) {
    final clipRectChild = widget.child;
    if (clipRectChild == null) return widget;

    return ClipRect(
      key: widget.key,
      clipBehavior: widget.clipBehavior,
      clipper: widget.clipper,
      child: _hideImages(clipRectChild),
    );
  }

  Widget _rebuildClipRRectWithFilteredChild(ClipRRect widget) {
    final clipRectChild = widget.child;
    if (clipRectChild == null) return widget;

    return ClipRRect(
      key: widget.key,
      borderRadius: widget.borderRadius,
      child: _hideImages(clipRectChild),
    );
  }

  Widget _rebuildClipOvalWithFilteredChild(ClipOval widget) {
    final clipOvalChild = widget.child;
    if (clipOvalChild == null) return widget;

    return ClipOval(
      key: widget.key,
      clipBehavior: widget.clipBehavior,
      clipper: widget.clipper,
      child: _hideImages(clipOvalChild),
    );
  }

  Widget _rebuildConstrainedBoxWithFilteredChild(ConstrainedBox widget) {
    final constrainedBoxChild = widget.child;
    if (constrainedBoxChild == null) return widget;

    return ConstrainedBox(
      key: widget.key,
      constraints: widget.constraints,
      child: _hideImages(constrainedBoxChild),
    );
  }

  Widget _rebuildRepaintBoundaryWithFilteredChild(RepaintBoundary widget) {
    final repaintBoundaryChild = widget.child;
    if (repaintBoundaryChild == null) return widget;

    return RepaintBoundary(
      key: widget.key,
      child: _hideImages(repaintBoundaryChild),
    );
  }

  Widget _rebuildExpandedWithFilteredChild(Expanded widget) {
    return Expanded(
      key: widget.key,
      flex: widget.flex,
      child: _hideImages(widget.child),
    );
  }

  Widget _rebuildDirectionalityChild(Directionality widget) {
    return Directionality(
      textDirection: widget.textDirection,
      child: _hideImages(widget.child),
      key: widget.key,
    );
  }

  Widget _rebuildListViewChildren(ListView widget) {
    if (!(widget.childrenDelegate is SliverChildListDelegate)) {
      return Text(
        "Unsupported ${widget.runtimeType.toString()} widget used in the overlay.",
        textDirection: TextDirection.ltr,
      );
    }

    var delegate = widget.childrenDelegate as SliverChildListDelegate;

    return ListView(
      children: delegate.children,
      addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
      addRepaintBoundaries: delegate.addRepaintBoundaries,
      addSemanticIndexes: delegate.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      clipBehavior: widget.clipBehavior,
      controller: widget.controller,
      dragStartBehavior: widget.dragStartBehavior,
      itemExtent: widget.itemExtent,
      itemExtentBuilder: widget.itemExtentBuilder,
      keyboardDismissBehavior: widget.keyboardDismissBehavior,
      padding: widget.padding,
      physics: widget.physics,
      primary: widget.primary,
      prototypeItem: widget.prototypeItem,
      restorationId: widget.restorationId,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      semanticChildCount: widget.semanticChildCount,
      shrinkWrap: widget.shrinkWrap,
      key: widget.key,
    );
  }
}
