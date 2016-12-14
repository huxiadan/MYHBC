//
//  HDLocaltion.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    定位
 */

#import <Foundation/Foundation.h>

#define kLocationGetCityNotification @"kHDLocationGetCityNotification"

typedef void(^GetCityBlock)(NSString *cityName);

@interface HDLocaltion : NSObject

/**
 通过定位获取地址

 @param block 获取到地址的回调
 */
- (void)getAddressFromLocaltionWithCityNameBlock:(GetCityBlock)block;

@end
