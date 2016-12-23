
//
//  Created by HB_YDZD on 16/4/8.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import "DataOrganize1.h"
@implementation DataOrganize1

// 欠缺方法补充

+ (NSDictionary *)returnCMDandDicdionary:(NSData *)data
{
    return nil;
}

// 欠缺方法补充

+(NSString *)HexToStr: (Byte *)ibuffer alllength: (int) ilength
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

+(NSString *)HexToStr: (NSData *)data
{
    Byte *ibuffer = (Byte *)[data bytes];
    return [self HexToStr:ibuffer alllength:(int)[data length]];
}


+ (Byte *)StrToHex: (NSString *)hexstring reBuffer:(Byte *)ibuffer
{
    if ([hexstring length]%2)
        return Nil;
    
    Byte *result = ibuffer; //alloca([hexstring length]/2);
    
    for (int i = 0; i< [hexstring length]; i += 2)
    {
        NSString *str1 = [hexstring substringWithRange:NSMakeRange(i, 2)];
        int ivalue = (int)strtoul([str1 UTF8String], 0, 16);
        result[i/2] = (ivalue & 0xff);
    }
    return result;
}

+ (NSData *)StrToHex: (NSString *)hexstring
{
    NSData *retdata = nil;
    Byte *result = alloca([hexstring length]/2);//new Byte[[hexstring length]/2];
    
    result = [self StrToHex:hexstring reBuffer:result];
    retdata = [[NSData alloc]initWithBytes:result length:[hexstring length]/2];
    
    return retdata;
}


+(Byte) btCardVerifyValue: (Byte *)cmddate  Offset: (int)offest Len:(int)len
{
    if(cmddate == NULL)
    {
        return (Byte) NULL;
    }
    Byte result = 0x00;
    for(int i=0 ; i< len ;i++)
    {
        result = (Byte) (result^cmddate[i+offest]);
    }
    return result;
}


+(Byte) btDataVerifyValue: (Byte *)cmddate  Offset: (int)offest Len:(int)len
{
    
    if(cmddate == NULL)
    {
        return (Byte) NULL;
    }
    Byte result = 0x00;
    for(int i=0 ; i< len ;i++)
    {
        result = (Byte) (result^cmddate[i+offest]);
    }
    return result;
}
+(NSDictionary *)HostToPOs:(NSData *)data//tlv解析
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    while ([data length]>0)
    {
        while ([data length]>0)
            {
                NSData *tag = [DataOrganize1 Tag:data];
               data = [data subdataWithRange:NSMakeRange([tag length], [data length]-[tag length])];
                NSData *lengthData = [DataOrganize1 length:data];
                data = [data subdataWithRange:NSMakeRange([lengthData length], [data length]-[lengthData length])];
                NSData *shujuData = [DataOrganize1 shuju:data len:lengthData];
                [dic setObject:shujuData forKey:[DataOrganize1 HexToStr:tag]];
                data = [data subdataWithRange:NSMakeRange([shujuData length], [data length]-[shujuData length])];
                [dic setObject:[DataOrganize1 HexToStr:shujuData] forKey:[DataOrganize1 HexToStr:tag]];
            }
        
            
    }
   // NSLog(@"tlv解析 = %@",dic);
    return dic;
}
+(NSData *)Tag:(NSData *)data//获取tag
{
    NSData *tagdata = [[NSData alloc]init];
    NSString *str = [DataOrganize1 HexToStr:[data subdataWithRange:NSMakeRange(0, 1)]];
    if ([str isEqualToString:@"1F"]||[str isEqualToString:@"5F"]||[str isEqualToString:@"7F"]||[str isEqualToString:@"9F"]||[str isEqualToString:@"DF"])
    {
        tagdata = [data subdataWithRange:NSMakeRange(0, 2)];
        
    }else
    {
        tagdata = [data subdataWithRange:NSMakeRange(0, 1)];
    }
   // NSLog(@"2 = %@",tagdata);
    return tagdata;
}
+(NSData *)length :(NSData *)data//获取长度
{
    NSData *redata = [[NSData alloc]init];
    NSString *str = [DataOrganize1 HexToStr:[data subdataWithRange:NSMakeRange(0, 1)]];
    NSString *str1 = [[NSString alloc]initWithFormat:@"%x",str.intValue];
    int length1 ;
    [[NSScanner scannerWithString:str1]scanInt:&length1];
    if (length1 == 81)
    {
        redata = [data subdataWithRange:NSMakeRange(0, 2)];
    }else if (length1 == 82)
    {
        redata = [data subdataWithRange:NSMakeRange(0, 3)];
    }else
    {
        redata = [data subdataWithRange:NSMakeRange(0, 1)];
    }
    //NSLog(@"3 = %@",redata);
    return redata;

}
+(NSData *)shuju:(NSData *)data len :(NSData *)lengthData//获取数据
{
    int shujulength ;
    [[NSScanner scannerWithString:[DataOrganize1 HexToStr:lengthData]] scanInt:&shujulength];
    
    NSData *data1 = [data subdataWithRange:NSMakeRange(0, shujulength)];
    //NSLog(@"4 = %@",data1);
    return data1;

    
}


@end
