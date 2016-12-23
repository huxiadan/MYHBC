//
//  HBtools.h
//  HBtools
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

/**
    加密解密工具类
 */

#import <Foundation/Foundation.h>
enum {
    ECB = 1,
    CBC = 0,
};
typedef uint32_t DES_TypeMode;

@interface HBtools : NSObject
/*
 @method  HBtools 单例模式
 */
+ (HBtools *)sharedInstance;

/*
 @method        DES
 @instructions
 @parameter     要加密的sText
 @return        加密后的str
 */
//DES加密
-(NSString *)encryptSting:(NSString *)sText key:(NSString *)key andDesiv:(NSString *)ivDes;
//DES解密
-(NSString *)decryptWithDESString:(NSString *)sText key:(NSString *)key andiV:(NSString *)iv;

/*
 @method        3DES （报文的加密、解密）
 @instructions  加密(Encrypt) / 解密(Decrypt)
 @parameter     要加密的srcStr  TypeMode CBC/ECB   KEY密钥key[24];ivs[8]
 @return        加密后的str
 */
-(NSString *)TripleDesDecrypt: (NSString *)srcStr withKEY:(NSString*)Key IV:(NSString *)Ivsring TypeMode:(DES_TypeMode)type;
-(NSString *)TripleDesEncrypt: (NSString *)srcStr withKEY:(NSString *)Key IV:(NSString *)Ivsring TypeMode:(DES_TypeMode)type;

/*
 @method        3DES（9f26密钥的加密、解密）3DES双倍、三倍长加解密
 @instructions  加密(Encrypt) / 解密(Decrypt)
 @parameter     要加密的srcStr
 @return        加密后的str
 */
-(NSString *)encrypt3DES: (NSString *)srcStr withKEY:(NSString*)Key;
-(NSString *)decrypt3DES: (NSString *)srcStr withKEY:(NSString*)Key;

/*
 @method        AES
 @instructions
 @parameter     要加密的data
 @return        data
 *///AES加密
- (NSData *)AES128EncryptWithKey1:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data;
//AES解密
- (NSData *)AES128DecryptWithKey:(NSString *)key iv:(NSString *)iv withNSData:(NSData *)data;
/*
 @method        SHA1HMAC 、SHA256、SHA512
 @instructions
 @parameter     要加密的str
 @return        data
 */
-(NSString *)SHA1HMACWithKey:(NSString *)key andMessage:(NSString *)str;
-(NSString *)SHA256HMACWithKey:(NSString *)key andMessage:(NSString *)str;
-(NSString *)SHA512HMACWithKey:(NSString *)key andMessage:(NSString *)str;

/*
 @method        RSA
 @instructions
 @parameter     要加密的data
 @return        data
 */
-(NSString *)RSAencryptString:(NSString *)originString publicKey:(NSString *)privateKey;
-(NSString *)RSAdecryptString:(NSString *)encWithPubKey privateKey:(NSString *)privateKey;
-(NSString *)RSAdecryptString:(NSString *)encWithPrivKey publicKey:(NSString *)publicKey;

/*
 @method        Base64
 @instructions  编码（Encode）／解码（Decrypt）
 @parameter     要编码的aStr
 @return        编码后的str
 */
-(NSString*)Base64Encodewith:(NSString*)aStr;

-(NSString*)Base64Decodewith:(NSString*)enStr;
/*
 @method        Base64
 @instructions  文本数据转换为base64格式字符串、base64格式字符串转换为文本数据
 @parameter     要处理的数据data、string
 @return
 */
-(NSString*)base64EncodedStringFrom:(NSData*)data;

-(NSData*)dataWithBase64EncodedString:(NSString*)string;
/*
 @method        进制转换
 @instructions  16进制转10进制int
 @parameter     要转换的HexStr
 @return        转换后的10进制
 */
-(unsigned long)HexStrTo10Int:(NSString *)HexStr;
/*
 @method        进制转换
 @instructions  StrToHex（10进制转16进制Data）／ HexToStr（16进制转10进制str）
 @parameter     要转换的string
 @return        转换后的16进制Data、str
 */
-(NSData *)StrToHex: (NSString *)string;

-(NSString *)HexToStr: (NSData *)Hexdata;
/*
 @method        MD5加密
 @instructions  加密
 @parameter     要转换的string、data及file路径
 @return        加密后的str
 */
- (NSString *)MD5forData:(NSData *)data;
- (NSString *)MD5forString:(NSString *)str;
- (NSString *)MD5forFile:(NSString *)str;
-(NSData *)MD5Digest:(NSString *)input encoding:(NSStringEncoding)encoding;
-(NSString *)MD5HexDigest:(NSString *)input encoding:(NSStringEncoding)encoding;

/*
 @method        TLV解析
 @instructions
 @parameter     要转换的string、data
 @return        加密后的dic
 */
-(NSDictionary*)TlvParsing:(NSData*)subdata;
-(NSDictionary*)TlvParsingHostToPOs:(NSData*)subdata;
-(NSDictionary*)TlvParsingHexfiled55:(NSString*)subdata;
-(void)MacGET;

@end
