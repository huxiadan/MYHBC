//
//  HDCreateQRCode.h
//  HDKit
//
//  Created by 胡丹 on 16/8/4.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  创建QRCode
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HDCreateQRCode : NSObject

/**
 *  根据内容创建二维码
 *
 *  @param content 内容
 *
 *  @return 生成的二维码图片
 */
+ (UIImage *)qrImageByContent:(NSString *)content;

/**
 *  根据内容创建指定大小的二维码图片
 *
 *  @param content 内容
 *  @param size    指定的大小
 *
 *  @return 生成的二维码图片
 */
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size;

/**
 *   色值 0~255
 */
/**
 *  根据内容生成指定颜色大小的二维码
 *
 *  @param content 内容
 *  @param size    大小
 *  @param red     R
 *  @param green   G
 *  @param blue    B
 *
 *  @return 生成的二维码图片
 */
+ (UIImage *)qrImageWithContent:(NSString *)content size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/**
 *  根据内容生成指定颜色带logo的二维码图片
 *
 *  @param content 内容
 *  @param logo    logo图片
 *  @param size    大小
 *  @param red     R
 *  @param green   G
 *  @param blue    B
 *
 *  @return 生成的二维码图片
 */
+ (UIImage *)qrImageWithContent:(NSString *)content logo:(UIImage *)logo size:(CGFloat)size red:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;


@end
