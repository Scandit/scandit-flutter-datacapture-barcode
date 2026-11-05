/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2026- Scandit AG. All rights reserved.
 */

import 'package:flutter/foundation.dart';
import 'package:scandit_flutter_datacapture_barcode/src/barcode.dart';

@immutable
class _BarcodeSpatialGridElement {
  final Barcode mainBarcode;
  final Barcode? subBarcode;

  const _BarcodeSpatialGridElement(this.mainBarcode, this.subBarcode);

  factory _BarcodeSpatialGridElement.fromJSON(Map<String, dynamic> json) {
    final mainBarcode = Barcode.fromJSON(json['mainBarcode']);
    final subBarcode = json['subBarcode'] != null ? Barcode.fromJSON(json['subBarcode']) : null;
    return _BarcodeSpatialGridElement(mainBarcode, subBarcode);
  }
}

/// Object that is returned by [BarcodeCountSession.getSpatialMap]. Represents the result of mapping the barcodes, and sub-barcodes if present, in a grid.
///
/// Depending on the scanned barcodes the grid could be incomplete so for some coordinates the returned barcode could be *null*.
///
/// Added in version 8.3.0
@immutable
class BarcodeSpatialGrid {
  final int _rows;
  final int _columns;
  final List<List<_BarcodeSpatialGridElement>> _grid;

  /// Returns the number of rows in the grid.
  ///
  /// Added in version 8.3.0
  int get rows => _rows;
  /// Returns the number of columns in the grid.
  ///
  /// Added in version 8.3.0
  int get columns => _columns;

  const BarcodeSpatialGrid._(this._rows, this._columns, this._grid);

  factory BarcodeSpatialGrid.fromJSON(Map<String, dynamic> json) {
    final rows = json['rows'] as int;
    final columns = json['columns'] as int;
    final gridJson = json['grid'] as List<dynamic>;

    final grid = gridJson
        .map((row) => (row as List<dynamic>)
            .map((element) => _BarcodeSpatialGridElement.fromJSON(element as Map<String, dynamic>))
            .toList())
        .toList();

    return BarcodeSpatialGrid._(rows, columns, grid);
  }

  /// Returns the barcode at the specified coordinates. If there is no barcode *null* is returned.
  ///
  /// Added in version 8.3.0
  Barcode? barcodeAt(int row, int column) {
    if (row >= 0 && row < _rows && column >= 0 && column < _columns) {
      return _grid[row][column].mainBarcode;
    }
    return null;
  }

  /// Returns an array of Barcodes corresponding to the selected row.
  ///
  /// Added in version 8.3.0
  List<Barcode> row(int index) {
    if (index >= 0 && index < _rows) {
      return _grid[index].map((element) => element.mainBarcode).toList();
    }
    return [];
  }

  /// Returns an array of barcodes corresponding to the selected column.
  ///
  /// Added in version 8.3.0
  List<Barcode> column(int index) {
    if (index >= 0 && index < _columns) {
      return _grid.map((row) => row[index].mainBarcode).toList();
    }
    return [];
  }
}
