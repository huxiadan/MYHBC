//
//  Hardware.m
//  TestData
//
//  Created by HB_YDZD on 16/4/11.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import "Hardware.h"




//#include <sys/socket.h> // Per msqr
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>

#pragma mark MAC addy

#import <UIKit/UIKit.h>



//ip


#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
//#import <dlfcn.h>
//#import "wwanconnect.h"//frome apple 你可能没有哦
//#import <SystemConfiguration/SystemConfiguration.h>

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to mlamb.
@implementation Hardware

// 欠缺方法补充
- (NSString *)localIPAddress
{
    return @"";
}

- (NSString *)macaddress
{
    return @"";
}

- (NSString *)getIPAddressForHost:(NSString *)theHost
{
    return @"";
}

- (NSString *)whatismyipdotcom
{
    return @"";
}

// 欠缺方法补充

- (NSString *) hostname
{
    return [[[UIDevice currentDevice]identifierForVendor]UUIDString];

}
- (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}


//
////------------------------以下未测试ok--------------------------------------
//- (NSString *) macaddress
//{
//    int                    mib[6];
//    size_t                len;
//    char                *buf;
//    unsigned char        *ptr;
//    struct if_msghdr    *ifm;
//    struct sockaddr_dl    *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1/n");
//        return NULL;
//    }
//    
//    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!/n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
//        return NULL;
//    }
//    
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    // NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    free(buf);
//    return [outstring uppercaseString];
//}
//
//- (NSString *) whatismyipdotcom
//{
//    NSError *error;
//    NSURL *ipURL = [NSURL URLWithString:@"http://www.whatismyip.com/automation/n09230945.asp"];
//    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
//    return ip ? ip : [error localizedDescription];
//}
//
//
////这是本地host的IP地址
//- (NSString *) localIPAddress
//{
//    struct hostent *host = gethostbyname([[self hostname] UTF8String]);
//    if (!host) {herror("resolv"); return nil;}
//    struct in_addr **list = (struct in_addr **)host->h_addr_list;
//    return [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
//}
//
////从host获取地址
//- (NSString *) getIPAddressForHost: (NSString *) theHost
//{
//    struct hostent *host = gethostbyname([theHost UTF8String]);
//    if (!host) {herror("resolv"); return NULL; }
//    struct in_addr **list = (struct in_addr **)host->h_addr_list;
//    NSString *addressString = [NSString stringWithCString:inet_ntoa(*list[0]) encoding:NSUTF8StringEncoding];
//    return addressString;
//}
@end
