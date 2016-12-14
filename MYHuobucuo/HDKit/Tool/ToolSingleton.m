//
//  ToolSingleton.m
//  HDKit
//
//  Created by 胡丹 on 16/8/2.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ToolSingleton.h"

@implementation ToolSingleton

SingletonM(ToolSingleton)

#pragma mark - Getter
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return _dateFormatter;

}

@end
