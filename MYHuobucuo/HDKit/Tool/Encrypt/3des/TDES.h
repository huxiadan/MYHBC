
#import <Foundation/Foundation.h>

@interface TDES : NSObject

void decrpt3DES(char *outbuf,char *data,char *myklk);
void encrpt3DES(char *outbuf,char *data,char *myklk);

void decrptDES(char *outbuf,char *data,char *myklk);
void encrptDES(char *outbuf,char *data,char *myklk);

void encrptDES(char *outbuf,char *data,char *myklk);
int IntToBcd11(int aa, char xx[2]);
void Hex2Str(char *sSrc,  char *sDest, int nSrcLen);
void Str2Hex(char *sSrc, char *sDest, int nSrcLen);

@end
