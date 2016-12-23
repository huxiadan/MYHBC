//分组密码的操作模式https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation#Cipher_Block_Chaining_.28CBC.29

//  Triple3DesUtils.h
//  HBLightPay
//
//  Created by HB on 15/10/21.
//  Copyright © 2015年 HB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HBBase64.h"
@interface Triple3DesUtils : NSObject
enum {
    DES_CBC = 0,
    DES_ECB = 1,
};
typedef uint32_t DES_TYPE;

-(NSString *)TripleDesDecrypt: (NSString *)srcStr andType:(DES_TYPE)type;
-(NSString *)TripleDesEncrypt: (NSString *)srcStr andType:(DES_TYPE)type;
-(NSString *)TripleDESEncrypt: (NSString *)srcStr withKey: (NSString *)akey IV:(NSString *)Ivsring andType:(DES_TYPE)type;
-(NSString *)TripleDesDecrypt: (NSString *)srcStr withKey: (NSString *)akey IV:(NSString *)Ivsring andType:(DES_TYPE)type;
@end
