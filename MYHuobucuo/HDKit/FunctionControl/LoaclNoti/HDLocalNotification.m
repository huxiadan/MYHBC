//
//  HDLocalNotification.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/10.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDLocalNotification.h"

@implementation HDLocalNotification

+ (void)registerLocalNotificationWithKey:(NSString *)key
                               alertTime:(NSInteger)alertTime
                                notiBody:(NSString *)notiBody
                            notiInfoDict:(NSDictionary *)notiInfoDict {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@",fireDate);
    
    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = kCFCalendarUnitSecond;
    
    // 通知内容
    notification.alertBody =  notiBody;
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary *userDict = notiInfoDict;
    notification.userInfo = userDict;
    
    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type=UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        UIUserNotificationSettings *setting=[UIUserNotificationSettings settingsForTypes:type categories:nil];
        [[UIApplication sharedApplication]registerUserNotificationSettings:setting];
    }
    // 通知重复提示的单位，可以是天、周、月
    notification.repeatInterval = NSDayCalendarUnit;
    
    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


+ (void)cancelLocalNotificationWithKey:(NSString *)key
{
    NSArray *notificaitons = [[UIApplication sharedApplication] scheduledLocalNotifications];
    //获取当前所有的本地通知
    if (!notificaitons || notificaitons.count <= 0) {
        return;
    }
    for (UILocalNotification *notify in notificaitons) {
        if ([[notify.userInfo objectForKey:@"id"] isEqualToString:key]) {
            //取消一个特定的通知
            [[UIApplication sharedApplication] cancelLocalNotification:notify];
            break;
        }
    }
}

+ (void)cancelAllLocalNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

@end
