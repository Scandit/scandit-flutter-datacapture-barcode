/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2025- Scandit AG. All rights reserved.
 */

// ignore: unnecessary_library_name
library scandit_flutter_datacapture_barcode_generator;

export 'src/generator/barcode_generator.dart'
    show
        BarcodeGenerator,
        BarcodeGeneratorBuilder,
        AztecBarcodeGeneratorBuilder,
        Code128BarcodeGeneratorBuilder,
        Code39BarcodeGeneratorBuilder,
        DataMatrixBarcodeGeneratorBuilder,
        Ean13BarcodeGeneratorBuilder,
        InterleavedTwoOfFiveBarcodeGeneratorBuilder,
        QrCodeBarcodeGeneratorBuilder,
        UpcaBarcodeGeneratorBuilder;
export 'src/generator/qr_code_crrection_level.dart' show QrCodeErrorCorrectionLevel;
