/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

library scandit_flutter_datacapture_barcode;

export 'src/scandit_flutter_datacapture_barcode.dart' show ScanditFlutterDataCaptureBarcode;
export 'src/barcode.dart' show Barcode, LocalizedOnlyBarcode;
export 'src/symbology.dart' show Symbology, SymbologySerializer, EncodingRange, Ean13UpcaClassification;
export 'src/symbology_description.dart' show SymbologyDescription, Range;
export 'src/symbology_settings.dart' show SymbologySettings, Checksum;
export 'src/composite_type.dart' show CompositeType, CompositeTypeSerializer;
export 'src/composite_type_description.dart' show CompositeTypeDescription;
export 'src/barcode_filter_settings.dart' show BarcodeFilterSettings;
export 'src/barcode_filter_highlight_settings.dart'
    show BarcodeFilterHighlightSettings, BarcodeFilterHighlightSettingsBrush, BarcodeFilterHighlightType;
