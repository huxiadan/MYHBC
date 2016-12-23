//
//  PublicTLV.m
//  TestData
//
//  Created by HB_YDZD on 16/4/15.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import "PublicTLV.h"
#import "PubUtil.h"
#import "TLVParseUtils.h"
#import "DataOrganize1.h"

@implementation PublicTLV

- (NSDictionary *)insert2Map:(NSData *)data
{
    NSMutableDictionary *resultMap = [[NSMutableDictionary alloc] init];
    Byte *msgContent = (Byte *)data.bytes;
   NSMutableData* totalAcctDetail = [[NSMutableData alloc] initWithCapacity:0];
    
    int index = 0;
    int totalLen = (int)data.length;
    while (index < totalLen) {
        NSString *tag = [[PubUtil sharedInstance] HexToStr:(Byte *)[[data subdataWithRange:NSMakeRange(index, 2)] bytes] alllength:2];
        index += 2;
        
        if ((index + 2) >= totalLen) {
            NSLog(@"长度错误");
            break;
        }
        
        int h = msgContent[index++] & 0xff;
        int l = msgContent[index++] & 0xff;
        int len = h * 256 + l;
        
        if ((index + len) > totalLen) {
            NSLog(@"index=%dlen= %d长度错误",index,len);
            break;
        }
        
        NSString *value = @"";
        if ([tag isEqualToString:@"0018"])
        {
            [totalAcctDetail appendData:[data subdataWithRange:NSMakeRange(index, len)]];
        }
        else
        {
            NSData *subdata = [data subdataWithRange:NSMakeRange(index, len)];
            char mybuffer[1024] = "";
            memcpy(mybuffer, [subdata bytes], [subdata length]);
            
            if([tag isEqualToString:@"001C"]){
                value = [[PubUtil sharedInstance] HexToStr:subdata];
            }else{
                value = [NSString stringWithCString:mybuffer encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
                //-530:0-530 EASYLINK:与DCC交易失败内存分配错误
                //K_9999:后台无公交开卡记录,不能进行
                //后端统一采用UTF8编码  湖州subdata数据多了一个C4导致无法解析
                if (value == nil) {
                    value = [[NSString alloc] initWithData:subdata encoding:NSASCIIStringEncoding];
                    if (value == nil) {
                        value = @"数据信息异常";
                        
                    }
                }
            }
        }
        [resultMap setObject:value forKey:tag];
        index += len;
        
    }

    
    return resultMap;
}
-(NSDictionary*)TlvParsingWithHexfiled55:(NSString*)hexfiled55{
    TLVParseUtils*s = [[TLVParseUtils alloc] init] ;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];

    NSArray *tlvArr =  [s saxUnionField55_2List:hexfiled55];
    for (TLV *tlv in tlvArr) {
        [dic setObject:tlv.value forKey:tlv.tag];
    }
    return dic;
}

-(NSDictionary*)HostToPOs:(NSData*)data{
    return  [DataOrganize1 HostToPOs:data];
    
}
@end
