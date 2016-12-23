//
//  HBtools.h
//  HBtools
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import "NSString+SHA1Digest.h"
#import "NSData+SHA1Digest.h"

@implementation NSString (SHA1Digest)

+(NSData *)SHA1Digest:(NSString *)input encoding:(NSStringEncoding)encoding {
    NSData* data = [input dataUsingEncoding:encoding];
    return [data SHA1Digest];
}

-(NSData *)SHA1DigestWithEncoding:(NSStringEncoding)encoding {
    NSData* data = [self dataUsingEncoding:encoding];
    return [data SHA1Digest];
}

-(NSData *)SHA1Digest {
    return [self SHA1DigestWithEncoding:NSUTF8StringEncoding];
}

+(NSString *)SHA1HexDigest:(NSString *)input encoding:(NSStringEncoding)encoding {
    NSData* data = [input dataUsingEncoding:encoding];
    return [data SHA1HexDigest];
}

-(NSString *)SHA1HexDigestWithEncoding:(NSStringEncoding)encoding {
    NSData* data = [self dataUsingEncoding:encoding];
    return [data SHA1HexDigest];
}

-(NSString *)SHA1HexDigest {
    return [self SHA1HexDigestWithEncoding:NSUTF8StringEncoding];
}

@end
