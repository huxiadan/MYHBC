//
//  HBtools.h
//  HBtools
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (SHA256Digest)

+(NSData *)SHA256Digest:(NSData *)input;
-(NSData *)SHA256Digest;

+(NSString *)SHA256HexDigest:(NSData *)input;
-(NSString *)SHA256HexDigest;

@end
