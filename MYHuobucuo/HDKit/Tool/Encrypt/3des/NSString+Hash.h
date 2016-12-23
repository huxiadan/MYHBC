


#import <Foundation/Foundation.h>

@interface NSString (Hash)
//3des
+ (NSString*)encrypt3DES:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decrypt3DES:(NSString*)plainText withKey:(NSString*)key;

@end
