//
//  Help.h
//  TestData
//
//  Created by HB_YDZD on 16/4/11.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

//MD5
+ (NSString *)MD5data:(NSData *)data;
+(NSString *)MD5file:(NSString*)path;
+(NSString*)MD5string:(NSString*)str;
//Base64
+ (NSString *)base64StringFromText:(NSString *)text;
+ (NSString *)textFromBase64String:(NSString *)base64;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
//DES加密
+(NSString *)encryptSting:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes;
//DES解密
+(NSString *)decryptWithDESString:(NSString *)sText key:(NSString *)key andiV:(NSString *)iv;
//AES加密
+ (NSData *)AES128EncryptWithKey1:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data;
//AES解密
+ (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data;
//HMAC-SHA1加密 和MD5加密
+ (NSString *) hmacSha512:(NSString*)key text:(NSString*)text;
@end
