//
//  HBtools.h
//  HBtools
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5Digest)

+(NSData *)MD5Digest:(NSString *)input encoding:(NSStringEncoding)encoding;
-(NSData *)MD5DigestWithEncoding:(NSStringEncoding)encoding;
-(NSData *)MD5Digest;

+(NSString *)MD5HexDigest:(NSString *)input encoding:(NSStringEncoding)encoding;
-(NSString *)MD5HexDigestWithEncoding:(NSStringEncoding)encoding;
-(NSString *)MD5HexDigest;

@end
