//
//  PubUtil.h
//  HBSDKForWatch
//
//  Created by HB on 15/10/4.
//  Copyright © 2015年 HB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PubUtil : NSObject


+ (PubUtil *)sharedInstance;

-(unsigned long)HexStrTo10Int:(NSString *)str;

-(NSData *)StrToHex: (NSString *)hexstring;
-(NSString *)HexToStr: (NSData *)data;

-(NSString *)HexToStr: (Byte *)ibuffer alllength: (unsigned long)ilength;
-(Byte *)StrToHex: (NSString *)hexstring reBuffer:(Byte *)ibuffer;

@end
