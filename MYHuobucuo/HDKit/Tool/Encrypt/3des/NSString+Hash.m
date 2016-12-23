

#import "NSString+hash.h"
#include <stdlib.h>
#import "TDES.h"//3des

@implementation NSString (Hash)

+ (NSString*)encrypt3DES:(NSString*)plainText withKey:(NSString*)key{
    NSString *mycode=plainText;
    NSString *myUpperCaseStringCode = [mycode uppercaseString];
    NSString *my3DESCodeStr = [NSString stringWithFormat:@""];
    
    for (int i = 0; i <(plainText.length/16); i++) {
        NSRange range = NSMakeRange(i*16, 16);
        NSString *iValue = [NSString stringWithFormat:@"%@",[myUpperCaseStringCode substringWithRange:range]];
        char *data = (char *)[iValue UTF8String];
        char *myklk = (char *)[key UTF8String];
        char *outbuf[30];
        memset (outbuf,0x00,30);
        encrpt3DES((char *)outbuf, data, myklk);
        NSString *encode = [[NSString alloc] initWithCString:(const char*)outbuf encoding:NSUTF8StringEncoding];
        my3DESCodeStr=[NSString stringWithFormat:@"%@%@",my3DESCodeStr,encode];
    }
    return my3DESCodeStr;
}

+ (NSString*)decrypt3DES:(NSString*)plainText withKey:(NSString*)key{
    
    NSString *mycode=plainText;
    NSString *myUpperCaseStringCode=[mycode uppercaseString];
    NSString *my3DESCodeStr=[NSString stringWithFormat:@""];
    
    for (int i = 0; i <(plainText.length/16); i++) {
        NSRange range=NSMakeRange(i*16, 16);
        NSString *iValue=[NSString stringWithFormat:@"%@",[myUpperCaseStringCode substringWithRange:range]];
        char *data = (char *)[iValue UTF8String];
        char *myklk= (char *)[key UTF8String];
        char *outbuf[30];
        memset (outbuf,0x00,30);
        decrpt3DES((char *)outbuf, data, myklk);
        NSString *encode = [[NSString alloc] initWithCString:(const char*)outbuf encoding:NSUTF8StringEncoding];
        my3DESCodeStr=[NSString stringWithFormat:@"%@%@",my3DESCodeStr,encode];
    }
    return my3DESCodeStr;
}

@end
