//
//  HDScanQRCodeView.h
//  HDKit
//
//  Created by 胡丹 on 16/8/4.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  扫描二维码视图
 */

// 需要添加AVFoundation框架
// 详细见简书：http://www.jianshu.com/p/dadb0c2ed863?utm_campaign=hugo&utm_medium=reader_share&utm_content=note

#import <UIKit/UIKit.h>

@class HDScanQRCodeView;

typedef void(^ScanResultBlock)(HDScanQRCodeView *scanView, NSString *info);

@interface HDScanQRCodeView : UIView

@property (nonatomic, assign, readonly) CGRect scanViewFrame;

@property (nonatomic, copy) ScanResultBlock scanResultBlock;    //  扫描结果的block

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  结束扫描
 */
- (void)endScan;

@end
