
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <Flutter/Flutter.h>
#import <scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode-Swift.h>
#import <ScanditCaptureCore/ScanditCaptureCore.h>
#import <ScanditBarcodeCapture/ScanditBarcodeCapture.h>

@interface BarcodeBatchTests : XCTestCase

@property (class, nonatomic, strong) id<FlutterBinaryMessenger> messenger;

@end

@implementation BarcodeBatchTests

static id<FlutterBinaryMessenger> _messenger;

+ (void)setUp {
    _messenger = (id<FlutterBinaryMessenger>)[[[UIApplication sharedApplication] keyWindow]
        rootViewController];
}

+ (void)setMessenger:(id<FlutterBinaryMessenger>)messenger {
    _messenger = messenger;
}

+ (id<FlutterBinaryMessenger>)messenger {
    return _messenger;
}

- (void)testDisposeIsCalledInBarcodeBatch {
    ScanditFlutterDataCaptureBarcodeBatch *batch = [[ScanditFlutterDataCaptureBarcodeBatch alloc]
                            initWith:BarcodeBatchTests.messenger
          simpleOverlayStreamHandler:OCMClassMock(BarcodeBatchBasicOverlayStreamHandler.class)
        advancedOverlayStreamHandler:OCMClassMock(BarcodeBatchAdvancedOverlayStreamHandler.class)];
    id mock = OCMPartialMock(batch);
    OCMStub([mock dispose]);
    ScanditFlutterDataCaptureBarcodeBatchModule *module =
        [[ScanditFlutterDataCaptureBarcodeBatchModule alloc] initWith:BarcodeBatchTests.messenger
                                                         barcodeBatch:mock];
    [module dispose];
    OCMVerify([mock dispose]);
}

- (void)testModeIsDisabledIfJSONValueIsFalse {
    ScanditFlutterDataCaptureBarcodeBatch *batch = [[ScanditFlutterDataCaptureBarcodeBatch alloc]
                            initWith:BarcodeBatchTests.messenger
          simpleOverlayStreamHandler:OCMClassMock(BarcodeBatchBasicOverlayStreamHandler.class)
        advancedOverlayStreamHandler:OCMClassMock(BarcodeBatchAdvancedOverlayStreamHandler.class)];
    SDCBarcodeBatch *btBatch = [SDCBarcodeBatch
        barcodeBatchWithContext:nil
                       settings:[SDCBarcodeBatchSettings settings]];
    SDCJSONValue *json = [SDCJSONValue JSONValueWithString:@"{\"enabled\": false}"];
    [batch barcodeBatchDeserializer:OCMClassMock(SDCBarcodeBatchDeserializer.class)
         didFinishDeserializingMode:btBatch
                      fromJSONValue:json];
    XCTAssertFalse(btBatch.isEnabled);
}

- (void)testModeIsEnabledIfJSONValueIsTrue {
    ScanditFlutterDataCaptureBarcodeBatch *batch = [[ScanditFlutterDataCaptureBarcodeBatch alloc]
                            initWith:BarcodeBatchTests.messenger
          simpleOverlayStreamHandler:OCMClassMock(BarcodeBatchBasicOverlayStreamHandler.class)
        advancedOverlayStreamHandler:OCMClassMock(BarcodeBatchAdvancedOverlayStreamHandler.class)];
    SDCBarcodeBatch *btBatch = [SDCBarcodeBatch
        barcodeBatchWithContext:nil
                       settings:[SDCBarcodeBatchSettings settings]];
    SDCJSONValue *json = [SDCJSONValue JSONValueWithString:@"{\"enabled\": true}"];
    [batch barcodeBatchDeserializer:OCMClassMock(SDCBarcodeBatchDeserializer.class)
         didFinishDeserializingMode:btBatch
                      fromJSONValue:json];
    XCTAssertTrue(btBatch.isEnabled);
}

@end
