//
//  Hardware.h
//  TestData
//
//  Created by HB_YDZD on 16/4/11.
//  Copyright © 2016年 HB_YDZF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hardware : NSObject
- (NSString *) macaddress;

- (NSString *) hostname;
- (NSString *) localWiFiIPAddress;

- (NSString *) getIPAddressForHost: (NSString *) theHost;
- (NSString *) localIPAddress;
- (NSString *) whatismyipdotcom;


@end
