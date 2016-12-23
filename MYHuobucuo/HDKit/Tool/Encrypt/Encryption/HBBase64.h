//
//  Base64.h
//  HBLightPay
//
//  Created by HB on 15/10/23.
//  Copyright © 2015年 HB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HBBase64 : NSObject

+(NSString *)encode:(NSData *)data Option:(NSDataBase64EncodingOptions)option;
+(NSData *)decode:(NSString *)base64string;//解码

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
@end
