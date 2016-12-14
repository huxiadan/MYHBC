//
//  MYProgressHUD.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/24.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIImage,UIColor;

@interface MYProgressHUD : NSObject

/**
 *  黑色背景的view
 *
 *  @param message 显示文字
 */
+ (void)showAlertWithMessage:(NSString *)message;

/**
 *  白色背景的view
 *
 *  @param message 显示文字
 */
+ (void)showWhiteAlertWithMessage:(NSString *)message;

/**
 *  等待视图
 *
 *  @param message 显示文字
 */
+ (void)showWaitingViewWithMessage:(NSString *)message;

/**
 *  取消等待视图
 */
+ (void)dismissMessageView;

/**
 *  自定义显示图片的View,
 *
 *  @param message 显示文字
 *  @param image   自定义显示的图片
 */
+ (void)showAlterWithMessage:(NSString *)message image:(UIImage *)image backgroundColor:(UIColor *)bgColor;

@end
