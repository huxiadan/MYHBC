//
//  HDWebView.m
//  HDKit
//
//  Created by 1233go on 16/7/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDWebView.h"

#import <JavaScriptCore/JavaScriptCore.h>

@implementation HDWebView

#pragma mark - Public
- (void)setCookieWithUrl:(NSURL *)url cookieName:(NSString *)cookieName cookieValue:(NSString *)cookieValue
{
    // 设定 cookie
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:
                                @{[url host]:  NSHTTPCookieDomain,
                                  [url path]:  NSHTTPCookiePath,
                                  cookieName:  NSHTTPCookieName,
                                  cookieValue: NSHTTPCookieValue}];
    
    // 设定 cookie 到 storage 中
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

#pragma mark - Setter
- (void)setHideScrollBar:(BOOL)hideScrollBar
{
    for (UIView *subView in [self subviews]) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            // 右侧滚动条隐藏
            [(UIScrollView *)subView setShowsVerticalScrollIndicator:hideScrollBar];
            
            // 左侧滚动条隐藏
            [(UIScrollView *)subView setShowsHorizontalScrollIndicator:hideScrollBar];
            
            for (UIView *inScrollView in [subView subviews]) {
                if ([inScrollView isKindOfClass:[UIImageView class]]) {
                    [inScrollView setHidden:hideScrollBar];     // 上下滚动出边界时的黑色的图片
                }
            }
        }
    }
}

@end
