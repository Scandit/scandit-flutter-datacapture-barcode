/*
 * This file is part of the Scandit Data Capture SDK
 *
 * Copyright (C) 2020- Scandit AG. All rights reserved.
 */

#import "ScanditFlutterDataCaptureBarcodePlugin.h"

#import <scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode-Swift.h>

@interface ScanditFlutterDataCaptureBarcodePlugin ()

@property (class, nonatomic, strong) ScanditFlutterDataCaptureBarcodePlugin *instance;

@property (nonatomic, strong) ScanditFlutterDataCaptureBarcodeModule *coreInstance;
@property (nonatomic, strong) ScanditFlutterDataCaptureBarcodeCaptureModule *barcodeCaptureInstance;
@property (nonatomic, strong)
    ScanditFlutterDataCaptureBarcodeTrackingModule *barcodeTrackingInstance;
@property (nonatomic, strong)
    ScanditFlutterDataCaptureBarcodeSelectionModule *barcodeSelectionModule;
@property (nonatomic, strong) ScanditFlutterDataCaptureBarcodeCountModule *barcodeCountModule;

- (instancetype)
    initWithBarcodeInstance:(ScanditFlutterDataCaptureBarcodeModule *)coreInstance
     barcodeCaptureInstance:(ScanditFlutterDataCaptureBarcodeCaptureModule *)barcodeCaptureInstance
    barcodeTrackingInstance:
        (ScanditFlutterDataCaptureBarcodeTrackingModule *)barcodeTrackingInstance
     barcodeSelectionModule:
         (ScanditFlutterDataCaptureBarcodeSelectionModule *)barcodeSelectionModule
         barcodeCountModule:(ScanditFlutterDataCaptureBarcodeCountModule *)barcodeCountModule;

@end

@implementation ScanditFlutterDataCaptureBarcodePlugin

static ScanditFlutterDataCaptureBarcodePlugin *_instance;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    ScanditFlutterDataCaptureBarcodeModule *coreInstance =
        [[ScanditFlutterDataCaptureBarcodeModule alloc] initWith:[registrar messenger]];
    ScanditFlutterDataCaptureBarcodeCaptureModule *barcodeCaptureInstance =
        [[ScanditFlutterDataCaptureBarcodeCaptureModule alloc] initWith:[registrar messenger]];

    BarcodeTrackingBasicOverlayStreamHandler *basicStreamHandler =
        [[BarcodeTrackingBasicOverlayStreamHandler alloc] init];
    BarcodeTrackingAdvancedOverlayStreamHandler *advancedStreamHandler =
        [[BarcodeTrackingAdvancedOverlayStreamHandler alloc] init];
    ScanditFlutterDataCaptureBarcodeTracking *barcodeTracking =
        [[ScanditFlutterDataCaptureBarcodeTracking alloc] initWith:[registrar messenger]
                                        simpleOverlayStreamHandler:basicStreamHandler
                                      advancedOverlayStreamHandler:advancedStreamHandler];
    ScanditFlutterDataCaptureBarcodeTrackingModule *barcodeTrackingInstance =
        [[ScanditFlutterDataCaptureBarcodeTrackingModule alloc] initWith:[registrar messenger]
                                                         barcodeTracking:barcodeTracking];
    ScanditFlutterDataCaptureBarcodeSelection *selection =
        [[ScanditFlutterDataCaptureBarcodeSelection alloc]
            initWithBinaryMessenger:registrar.messenger];
    ScanditFlutterDataCaptureBarcodeSelectionModule *selectionModule =
        [[ScanditFlutterDataCaptureBarcodeSelectionModule alloc]
            initWithMessenger:registrar.messenger
             barcodeSelection:selection];
    ScanditFlutterDataCaptureBarcodeCountModule *barcodeCountModule =
        [[ScanditFlutterDataCaptureBarcodeCountModule alloc] initWith:registrar.messenger];
    ScanditFlutterDataCaptureBarcodePlugin *instance =
        [[ScanditFlutterDataCaptureBarcodePlugin alloc]
            initWithBarcodeInstance:coreInstance
             barcodeCaptureInstance:barcodeCaptureInstance
            barcodeTrackingInstance:barcodeTrackingInstance
             barcodeSelectionModule:selectionModule
                 barcodeCountModule:barcodeCountModule];
    self.instance = instance;
    FlutterBarcodeCountViewFactory *viewFactory = [[FlutterBarcodeCountViewFactory alloc]
        initWithBarcodeCountPlugin:barcodeCountModule.barcodeCount];
    [registrar registerViewFactory:viewFactory withId:@"com.scandit.BarcodeCountView"];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    result(FlutterMethodNotImplemented);
}

+ (void)setInstance:(ScanditFlutterDataCaptureBarcodePlugin *)instance {
    _instance = instance;
}

+ (ScanditFlutterDataCaptureBarcodePlugin *)instance {
    return _instance;
}

- (instancetype)
    initWithBarcodeInstance:(ScanditFlutterDataCaptureBarcodeModule *)coreInstance
     barcodeCaptureInstance:(ScanditFlutterDataCaptureBarcodeCaptureModule *)barcodeCaptureInstance
    barcodeTrackingInstance:
        (ScanditFlutterDataCaptureBarcodeTrackingModule *)barcodeTrackingInstance
     barcodeSelectionModule:
         (ScanditFlutterDataCaptureBarcodeSelectionModule *)barcodeSelectionModule
         barcodeCountModule:(ScanditFlutterDataCaptureBarcodeCountModule *)barcodeCountModule {
    if (self = [super init]) {
        _coreInstance = coreInstance;
        _barcodeCaptureInstance = barcodeCaptureInstance;
        _barcodeTrackingInstance = barcodeTrackingInstance;
        _barcodeSelectionModule = barcodeSelectionModule;
        _barcodeCountModule = barcodeCountModule;
    }
    return self;
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    [self.coreInstance dispose];
    [self.barcodeCaptureInstance dispose];
    [self.barcodeTrackingInstance dispose];
    [self.barcodeSelectionModule dispose];
    [self.barcodeCountModule dispose];
    [ScanditFlutterDataCaptureBarcodePlugin setInstance:nil];
}

@end
