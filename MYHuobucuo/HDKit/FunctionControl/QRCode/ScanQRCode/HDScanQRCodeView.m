//
//  HDScanQRCodeView.m
//  HDKit
//
//  Created by 胡丹 on 16/8/4.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDScanQRCodeView.h"

#import <AVFoundation/AVFoundation.h>

#import "HDDeviceInfo.h"
#import "HDImageTool.h"

@interface HDScanQRCodeView () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *avSession;

@property (nonatomic, strong) UIImageView *scanView;

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, assign) CGRect scanViewFrame;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@end

@implementation HDScanQRCodeView

#pragma mark - Public 
- (void)startScan
{
    self.lineView.hidden = NO;
    [self.avSession startRunning];
}

- (void)endScan
{
    self.lineView.hidden = YES;
    [self.avSession stopRunning];
}

#pragma mark - Private

- (instancetype)init
{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
        
        self.width = CGRectGetWidth(frame);
        self.height = CGRectGetHeight(frame);
    }
    return self;
}


- (void)initView
{
    UIImage *scanImage = [UIImage imageNamed:@""];
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat scanWidth = fScreen6(200);
    CGRect scanFrame = CGRectMake((width - scanWidth)/2, (height - scanWidth)/2, scanWidth, scanWidth);
    self.scanViewFrame = scanFrame;
    
    self.scanView = [[UIImageView alloc] initWithImage:scanImage];
    [self.scanView setBackgroundColor:[UIColor clearColor]];
    [self.scanView setFrame:scanFrame];
    [self addSubview:self.scanView];
    
    // 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // 闪光灯
    if ([device hasFlash] && [device hasTorch]) {
        [device lockForConfiguration:nil];
        [device setFlashMode:AVCaptureFlashModeAuto];
        [device setTorchMode:AVCaptureTorchModeAuto];
        [device unlockForConfiguration];
    }
    
    // 创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // 创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 设置代理，刷新线程
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = [self rectOfInterestByScanViewRect:self.scanView.frame];
    
    // 初始化连接对象
    self.avSession = [[AVCaptureSession alloc] init];
    // 采集率
    self.avSession.sessionPreset = AVCaptureSessionPresetHigh;
    
    if (input) {
        [self.avSession addInput:input];
    }
    
    if (output) {
        [self.avSession addOutput:output];
        
        // 设置扫码支持的编码格式
        NSMutableArray *typeArray = [NSMutableArray arrayWithCapacity:0];
        
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [typeArray addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [typeArray addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [typeArray addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [typeArray addObject:AVMetadataObjectTypeCode128Code];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
        }
        
        output.metadataObjectTypes = [typeArray copy];
        
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.avSession];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = self.bounds;
        [self.layer insertSublayer:layer above:0];
        [self bringSubviewToFront:self.scanView];
        [self setBlurView];
        [self.avSession startRunning];
        [self loopDrawLine];
    }
}

/**
 *  设置扫描区域
 *
 *  @param rect 整个区域
 *
 *  @return 扫描的区域
 */
- (CGRect)rectOfInterestByScanViewRect:(CGRect)rect
{
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat x = (height - CGRectGetHeight(rect))/2/height;
    CGFloat y = (width - CGRectGetWidth(rect))/2/height;
    
    CGFloat w = CGRectGetHeight(rect)/height;
    CGFloat h = CGRectGetWidth(rect)/width;
    
    return CGRectMake(x, y, w, h);
}

/**
 *  添加模糊效果
 */
- (void)setBlurView
{
    CGFloat width = self.width;
    CGFloat height = self.height;
    
    CGFloat x = CGRectGetMinX(self.scanView.frame);
    CGFloat y = CGRectGetMinY(self.scanView.frame);
    CGFloat w = CGRectGetWidth(self.scanView.frame);
    CGFloat h = CGRectGetHeight(self.scanView.frame);
    
    [self creatView:CGRectMake(0, 0, width, y)];
    [self creatView:CGRectMake(0, y + h, width, height - y)];
    [self creatView:CGRectMake(0, y, x, h)];
    [self creatView:CGRectMake(x + w, y, x, h)];
}

- (void)creatView:(CGRect)rect{
    CGFloat alpha = 0.5;
    UIView *view = [[UIView alloc]initWithFrame:rect];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = alpha;
    [self addSubview:view];
}

/**
 *  扫描动画
 */
- (void)loopDrawLine
{
    UIImage *lineImage = [HDImageTool imageWithColor:[UIColor whiteColor]];
    
    CGFloat x = CGRectGetMinX(_scanView.frame);
    CGFloat y = CGRectGetMinY(_scanView.frame);
    CGFloat w = CGRectGetWidth(_scanView.frame);
    CGFloat h = CGRectGetHeight(_scanView.frame);
    
    CGRect start = CGRectMake(x, y, w, 2);
    CGRect end = CGRectMake(x, y + h - 2, w, 2);
    
    if (!self.lineView) {
        self.lineView = [[UIImageView alloc]initWithImage:lineImage];
        self.lineView.contentMode = UIViewContentModeScaleAspectFill;
        self.lineView.frame = start;
        [self addSubview:self.lineView];
    }else{
        self.lineView.frame = start;
    }
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:2 animations:^{
        self.lineView.frame = end;
    } completion:^(BOOL finished) {
        [weakSelf loopDrawLine];
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count>0) {
        
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects firstObject];
        
        if (self.scanResultBlock) {
            self.scanResultBlock(self, metadataObject.stringValue);
        }
    }
}

@end
