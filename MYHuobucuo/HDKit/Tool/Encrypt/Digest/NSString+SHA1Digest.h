//
//  HBtools.h
//  HBtools
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA1Digest)

+(NSData *)SHA1Digest:(NSString *)input encoding:(NSStringEncoding)encoding;
-(NSData *)SHA1DigestWithEncoding:(NSStringEncoding)encoding;
-(NSData *)SHA1Digest;

+(NSString *)SHA1HexDigest:(NSString *)input encoding:(NSStringEncoding)encoding;
-(NSString *)SHA1HexDigestWithEncoding:(NSStringEncoding)encoding;
-(NSString *)SHA1HexDigest;

@end
