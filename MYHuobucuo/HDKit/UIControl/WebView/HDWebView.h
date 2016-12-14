//
//  HDWebView.h
//  HDKit
//
//  Created by 1233go on 16/7/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JSContextBlock)(NSArray *args);

@interface HDWebView : UIWebView

@property (nonatomic, assign) BOOL hideScrollBar;   // 隐藏滚动条

/**
 *  根据URL设置cookie
 *
 *  @param url         URL
 *  @param cookieName  cookie的名称
 *  @param cookieValue cookie的值
 */
- (void)setCookieWithUrl:(NSURL *)url cookieName:(NSString *)cookieName cookieValue:(NSString *)cookieValue;

@end
