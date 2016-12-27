//
//  HDWebView.m
//  HDKit
//
//  Created by 1233go on 16/7/29.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDWebView.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface HDWebView () <UIWebViewDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation HDWebView

#pragma mark - Public

- (instancetype)initWithNavController:(UINavigationController *)naviController hasTitleView:(BOOL)hasTitleView titleText:(NSString *)titleText
{
    if (self = [super init]) {
        
        self.navigationController = naviController;
        self.delegate = self;
        self.scalesPageToFit = YES;
    }
    return self;
}

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

#pragma mark - webView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{}

#pragma mark - Setter
- (void)setHideScrollBar:(BOOL)hideScrollBar
{
    _hideScrollBar = hideScrollBar;
    
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

- (void)setHtmlURL:(NSString *)htmlURL
{
    _htmlURL = [htmlURL stringByAddingPercentEscapesUsingEncoding:NSUnicodeStringEncoding];
    
    NSURL *url = [NSURL URLWithString:_htmlURL];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [self loadRequest:request];
}

@end
