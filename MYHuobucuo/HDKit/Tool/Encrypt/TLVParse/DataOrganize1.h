
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataOrganize1 : NSObject
+(NSString *)HexToStr: (Byte *)ibuffer alllength: (int) ilength;
+(NSString *)HexToStr: (NSData *)data;
+ (Byte *)StrToHex: (NSString *)hexstring reBuffer:(Byte *)ibuffer;
+ (NSData *)StrToHex: (NSString *)hexstring;

+(NSDictionary *)HostToPOs:(NSData *)data;//tlv解析
+(NSData *)Tag:(NSData *)data;
+(NSData *)length :(NSData *)data;
+(NSData *)shuju:(NSData *)data len :(NSData *)lengthData;
+(NSDictionary *)returnCMDandDicdionary:(NSData *)data;

@end
