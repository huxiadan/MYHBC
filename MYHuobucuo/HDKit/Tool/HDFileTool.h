//
//  HDFileTool.h
//  HDKit
//
//  Created by 胡丹 on 16/8/2.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
 *  文件工具类（文件读写，文件路径）
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger) {
    HDFilePathType_Document = 0,    // document目录,所有de应用程序数据文件写入到这个目录下。这个目录用于存储用户数据或其它应该定期备份的信息。
    HDFilePathType_Temp     = 1,    // tmp目录，这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息。
    HDFilePathType_Cache    = 2,    // cache目录，library的子目录。用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息。
}HDFilePathType;

@interface HDFileTool : NSObject

+ (NSString *)getPathWithPathType:(HDFilePathType)type;

@end
