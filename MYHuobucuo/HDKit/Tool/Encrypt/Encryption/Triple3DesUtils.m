//
//  Triple3DesUtils.m
//  HBLightPay
//
//  Created by HB on 15/10/21.
//  Copyright © 2015年 HB. All rights reserved.
//

#import "Triple3DesUtils.h"
#import <CommonCrypto/CommonCryptor.h>

@interface Triple3DesUtils()

@end


@implementation Triple3DesUtils


-(id)init
{
    if (self != nil) {
        self = [super init];
    }
    return self;
}

/**解密

 */
-(NSString *)TripleDesDecrypt: (NSString *)srcStr andType:(DES_TYPE)type
{
    return [self doCipher:srcStr keyString:@"HCEHCEHCEHCEHCEHCEHCEHCE" ivString:@"12341234" enc:kCCDecrypt andType:type ];

}

/** 加密
 *CBC模式 key[24];ivs[8];ivs使用
 *ECB模式 key[24];ivs[8]忽略;
 */
-(NSString *)TripleDesEncrypt: (NSString *)srcStr andType:(DES_TYPE)type
{
    
    return [self doCipher:srcStr keyString:@"HCEHCEHCEHCEHCEHCEHCEHCE" ivString:@"12341234" enc:kCCEncrypt andType:type ];

}
/**
 * DES加密
 * @param srcStr 加密原文
 * @return
 * 这里增加了Key的导入
 */
-(NSString *)TripleDESEncrypt: (NSString *)srcStr withKey: (NSString *)akey IV:(NSString *)Ivsring andType:(DES_TYPE)type
{

    return [self doCipher:srcStr keyString:akey ivString:Ivsring enc:kCCEncrypt andType:type ];

}

/**
 * DES解密
 * @param srcStr 加密原文
 * @return
 * 这里增加了Key的导入
 */
-(NSString *)TripleDesDecrypt: (NSString *)srcStr withKey: (NSString *)akey IV:(NSString *)Ivsring andType:(DES_TYPE)type
{
    return [self doCipher:srcStr keyString:akey ivString:Ivsring enc:kCCDecrypt andType:type ];
}

- (NSString*)doCipher:(NSString*)plainText keyString:(NSString*)keyString ivString:(NSString*)ivString enc:(CCOperation)encryptOrDecrypt andType:(DES_TYPE)type{
    
    if(plainText.length == 0||keyString.length==0||(ivString.length==0&&type==0)){
            return@"";
    }
    const void *vplainText;
    size_t plainTextBufferSize;
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
         NSData *EncryptData = [HBBase64 decode:plainText];
         plainTextBufferSize = [EncryptData length];
         vplainText = [EncryptData bytes];
     }else//加密
     {
         plainTextBufferSize = [plainText length];
         vplainText = (const void *) [plainText UTF8String];
     }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);

    
    const void * result1= (const void *)[keyString UTF8String];
    const void * IV3= (const void *)[ivString UTF8String];
//    void *result1 = key;
//    void *IV3 = ivs;
    
    uint8_t iv[kCCBlockSize3DES];
    memset((void *) iv, 0x0, (size_t) sizeof(iv));
    if (type==1) {//ECB是电码本模式 IV3参数不影响加密结果
        ccStatus = CCCrypt(encryptOrDecrypt,
                           kCCAlgorithm3DES,
                           (kCCOptionPKCS7Padding|kCCOptionECBMode),
                           result1,             //"123456789012345678901234", //key
                           kCCKeySize3DES,
                           IV3 ,                //iv,
                           vplainText,          //plainText,
                           plainTextBufferSize,
                           (void *)bufferPtr,
                           bufferPtrSize,
                           &movedBytes);
    }else{//CBC密码分组链接模式
        ccStatus = CCCrypt(encryptOrDecrypt,
                           kCCAlgorithm3DES,
                           kCCOptionPKCS7Padding ,
                           result1,             //"123456789012345678901234", //key
                           kCCKeySize3DES,
                           IV3 ,                //iv,
                           vplainText,          //plainText,
                           plainTextBufferSize,
                           (void *)bufferPtr,
                           bufferPtrSize,
                           &movedBytes);
    }
    if (ccStatus != kCCSuccess) {
        return nil;
    }
    NSString *result;
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [ [NSString alloc] initWithData: [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes] encoding:NSASCIIStringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:
                          (NSUInteger)movedBytes];
        result = [HBBase64 encode:myData Option:NSDataBase64EncodingEndLineWithLineFeed];
    }
    return result;
}

@end
