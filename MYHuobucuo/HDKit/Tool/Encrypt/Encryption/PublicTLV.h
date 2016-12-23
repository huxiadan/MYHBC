//
//  PublicTLV.h
//  TestData
//
//  Created by HB_YDZD on 16/4/15.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublicTLV : NSObject
//tlv解析
- (NSDictionary *)insert2Map:(NSData *)data;
//55域tlv的解析
-(NSDictionary*)TlvParsingWithHexfiled55:(NSString*)hexfiled55;
//tlv解析
-(NSDictionary*)HostToPOs:(NSData*)data;
@end
