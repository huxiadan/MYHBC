//
//  ToolSingleton.h
//  HDKit
//
//  Created by 胡丹 on 16/8/2.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  工具类的单例，用来缓存NSDataFormatter等
 */

#import <Foundation/Foundation.h>

#import "Singleton.h"

#define fShareToolInstance [ToolSingleton sharedToolSingleton]


@interface ToolSingleton : NSObject

SingletonH(ToolSingleton)

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end
