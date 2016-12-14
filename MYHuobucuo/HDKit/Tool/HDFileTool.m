//
//  HDFileTool.m
//  HDKit
//
//  Created by 胡丹 on 16/8/2.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDFileTool.h"

@implementation HDFileTool

+ (NSString *)getPathWithPathType:(HDFilePathType)type
{
    NSString *path;
    
    switch (type) {
        case HDFilePathType_Document:
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            path = [paths objectAtIndex:0];
        }
            break;
        case HDFilePathType_Cache:
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            path = [paths objectAtIndex:0];
        }
            break;
        case HDFilePathType_Temp:
        default:
        {
            path = NSTemporaryDirectory();
        }
            break;
    }
    
    return path;
}

@end
