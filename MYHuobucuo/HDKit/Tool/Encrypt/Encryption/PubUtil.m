//
//  PubUtil.m
//  HBSDKForWatch
//
//  Created by HB on 15/10/4.
//  Copyright © 2015年 HB. All rights reserved.
//

#import "PubUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation PubUtil

+ (PubUtil *)sharedInstance
{
    static PubUtil *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(unsigned long)HexTo10Int:(NSData *)data
{
    unsigned long isum = 0;
    Byte *pbuffer = (Byte *)[data bytes];
    
    for (int i = 0; i < [data length]; i++)
        isum = (isum << 8) | *(pbuffer +i);
    
    return isum;
}

-(unsigned long)HexStrTo10Int:(NSString *)str
{
    return [self HexTo10Int:[self StrToHex:str]];
}



#pragma mark General Routines
- (Byte *)StrToHex: (NSString *)hexstring reBuffer:(Byte *)ibuffer
{
    
    if ([hexstring length]%2)
        return Nil;
    
    Byte *result = ibuffer;
    for (int i = 0; i< [hexstring length]; i += 2)
    {
        
        NSString *str1 = [hexstring substringWithRange:NSMakeRange(i, 2)];
        unsigned long ivalue = strtoul([str1 UTF8String], 0, 16);
        result[i/2] = (ivalue & 0xff);
    }
    return result;
}

- (NSData *)StrToHex: (NSString *)hexstring
{

    NSData *retdata = nil;
    
    Byte result[2048] ={0};
    [self StrToHex:hexstring reBuffer:result];
    retdata = [[NSData alloc]initWithBytes:result length:[hexstring length]/2];
    
    return retdata;
}

-(NSString *)HexToStr: (Byte *)ibuffer alllength: (unsigned long)ilength
{
    NSString *strresult = [[NSString alloc]init];
    
    for(int i = 0; i< ilength; i++)
    {
        int ivalue = ibuffer[i];
        NSString *stringint = [NSString stringWithFormat:@"%02X", ivalue];
        strresult = [[NSString alloc]initWithFormat:@"%@%@", strresult, stringint];
    }
    return strresult;
}


-(NSString *)HexToStr: (NSData *)data
{
    Byte *ibuffer = (Byte *)[data bytes];
    return [self HexToStr:ibuffer alllength:[data length]];
}



@end
