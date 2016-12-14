//
//  HDLocalNotification.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/10.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    本地通知
 */

#import <Foundation/Foundation.h>

@interface HDLocalNotification : NSObject

/**
 注册本地推送

 @param key          通知的 key 值
 @param alertTime    推送的时间
 @param notiBody     推送通知栏显示的内容
 @param notiInfoDict 推送附带的信息
 */
+ (void)registerLocalNotificationWithKey:(NSString *)key alertTime:(NSInteger)alertTime notiBody:(NSString *)notiBody notiInfoDict:(NSDictionary *)notiInfoDict;

/**
 取消某个本地通知

 @param key 本地推送的 key
 */
+ (void)cancelLocalNotificationWithKey:(NSString *)key;

/**
 取消所有本地通知
 */
+ (void)cancelAllLocalNotification;

@end
