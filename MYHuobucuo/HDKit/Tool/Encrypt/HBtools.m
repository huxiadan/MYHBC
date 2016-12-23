//
//  HBtools.m
//  HBtools
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import "HBtools.h"
#import <UIKit/UIKit.h>

#import "Triple3DesUtils.h"
#import "PubUtil.h"
#import "Helper.h"

//#include "H_Des.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

#import "NSString+MD5Digest.h"
#import "NSString+SHA1Digest.h"
#import "NSString+SHA256Digest.h"

#import "NSString+MD5HMAC.h"
#import "NSString+SHA1HMAC.h"
#import "NSString+SHA256HMAC.h"

#import "NSString+hash.h"   //3DES 双倍长加解密
#import "HBRSA.h"             //ras
#import "PublicTLV.h"

@implementation HBtools{
    Triple3DesUtils *Triple3Des;
    PubUtil *pubUtil;
    PublicTLV*tlvParse;
}
//单例模式
+ (HBtools *)sharedInstance
{
    static HBtools *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance InitialzieVariables];
    });
    return sharedInstance;
}

-(void)InitialzieVariables{
    Triple3Des=[[Triple3DesUtils alloc]init];
    pubUtil =[PubUtil sharedInstance];
    tlvParse=[[PublicTLV alloc]init];

}
//DES加密
-(NSString *)encryptSting:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes{
    return [Helper encryptSting:sText key:key andDesiv:ivDes];
}
//DES解密
-(NSString *)decryptWithDESString:(NSString *)sText key:(NSString *)key andiV:(NSString *)iv{
    return [Helper decryptWithDESString:sText key:key andiV:iv];

}
//3DES报文解密
-(NSString *)TripleDesDecrypt: (NSString *)srcStr withKEY:(NSString*)Key IV:(NSString *)Ivsring TypeMode:(DES_TypeMode)type{
    return [Triple3Des TripleDesDecrypt:srcStr withKey:Key IV:Ivsring andType:type];
}
//3DES报文加密
-(NSString *)TripleDesEncrypt: (NSString *)srcStr withKEY:(NSString *)Key IV:(NSString *)Ivsring TypeMode:(DES_TypeMode)type{
        return [Triple3Des TripleDesDecrypt:srcStr withKey:Key IV:Ivsring andType:type];
}
//3DES密钥解密
-(NSString *)encrypt3DES: (NSString *)srcStr withKEY:(NSString*)Key {
    return [NSString encrypt3DES:srcStr withKey:Key];
}
//3DES密钥加密
-(NSString *)decrypt3DES: (NSString *)srcStr withKEY:(NSString*)Key {
    return [NSString decrypt3DES:srcStr withKey:Key];
}
//AES加密
- (NSData *)AES128EncryptWithKey1:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data{
    return [Helper AES128EncryptWithKey1:key iv:iv withNSData:data];
    
}
//AES解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data{
    return [Helper AES128DecryptWithKey:key iv:iv withNSData:data];
    
}
//SHA1HMAC
-(NSString *)SHA1HMACWithKey:(NSString *)key andMessage:(NSString *)str{
    return [str SHA1HMACWithKey:key];
}
//SHA512HMAC
-(NSString *)SHA512HMACWithKey:(NSString *)key andMessage:(NSString *)str{
    return [Helper hmacSha512:key text:str];
}
//SHA256HMAC
-(NSString *)SHA256HMACWithKey:(NSString *)key andMessage:(NSString *)str{
    return [str  SHA256HMACWithKey:key];
}
-(NSString *)RSAencryptString:(NSString *)originString publicKey:(NSString *)privateKey{
    return [HBRSA encryptString:originString publicKey:privateKey];
}
-(NSString *)RSAdecryptString:(NSString *)encWithPubKey privateKey:(NSString *)privateKey{
    return [HBRSA decryptString:encWithPubKey privateKey:privateKey];
}
-(NSString *)RSAdecryptString:(NSString *)encWithPrivKey publicKey:(NSString *)publicKey{
    return [HBRSA decryptString:encWithPrivKey publicKey:publicKey];
}
//Base64数据转码（加密）
-(NSString*)Base64Encodewith:(NSString*)aStr{
    if (aStr) {
        return [HBBase64 encode:[aStr dataUsingEncoding:NSUTF8StringEncoding]  Option:NSDataBase64EncodingEndLineWithLineFeed];
    }else{
        return nil;
    }
   
}
//Base64数据转码（解密）
-(NSString*)Base64Decodewith:(NSString*)enStr{
    if (enStr) {
        NSData *data64 = [HBBase64 decode:enStr];
         return [[NSString alloc]initWithData:data64 encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }

}
//文本数据转换为base64格式字符串
-(NSString*)base64EncodedStringFrom:(NSData*)data{
    return [HBBase64 base64EncodedStringFrom:data];
}
//base64格式字符串转换为文本数据
-(NSData*)dataWithBase64EncodedString:(NSString*)string{
   return  [HBBase64 dataWithBase64EncodedString:string];
}
//16进制转10进制int
-(unsigned long)HexStrTo10Int:(NSString *)HexStr{
    return  [pubUtil HexStrTo10Int:HexStr];

}
//10进制转16进制Data
-(NSData *)StrToHex: (NSString *)string{
    if (string) {
        return [pubUtil StrToHex:string];
        
    }else{
        return nil;
    }
}
//16进制转10进制str
-(NSString *)HexToStr: (NSData *)Hexdata{
    if (Hexdata) {
        return  [pubUtil HexToStr:Hexdata];
        
    }else{
        return nil;
    }
}
- (NSString *)MD5forData:(NSData *)data{
    if (data) {
        return  [Helper MD5data:data];
        
    }else{
        return nil;
    }
}
- (NSString *)MD5forString:(NSString *)str{
    if (str) {
        return  [Helper MD5string:str];
        
    }else{
        return nil;
    }
}
- (NSString *)MD5forFile:(NSString *)str{
    if (str) {
        return  [Helper MD5file:str];
        
    }else{
        return nil;
    }
}
-(NSData *)MD5Digest:(NSString *)input encoding:(NSStringEncoding)encoding{
    return [NSString MD5Digest:input encoding:encoding];
}
-(NSString *)MD5HexDigest:(NSString *)input encoding:(NSStringEncoding)encoding{
    return [NSString MD5HexDigest:input encoding:encoding];
}
//TLV 解析
-(NSDictionary*)TlvParsing:(NSData*)subdata{
    return [tlvParse insert2Map:subdata];
}
-(NSDictionary*)TlvParsingHostToPOs:(NSData*)subdata{
    return [tlvParse HostToPOs:subdata];
}
-(NSDictionary*)TlvParsingHexfiled55:(NSString*)subdata{
    return [tlvParse TlvParsingWithHexfiled55:subdata];
}

@end
