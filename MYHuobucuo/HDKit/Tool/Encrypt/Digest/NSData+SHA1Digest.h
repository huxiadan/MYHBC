//
//  HBtools.h
//  HBtools
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SHA1Digest)

+(NSData *)SHA1Digest:(NSData *)input;
-(NSData *)SHA1Digest;

+(NSString *)SHA1HexDigest:(NSData *)input;
-(NSString *)SHA1HexDigest;

@end
