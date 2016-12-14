//
//  HDTouchID.h
//  Test
//
//  Created by hudan on 16/9/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    TouchID 指纹校验
 */

#import <Foundation/Foundation.h>

typedef void(^TouchIDSuccessBlock)();
typedef void(^TouchIDFailBlock)(NSString *failReason);

@interface HDTouchID : NSObject

@property (nonatomic, copy) TouchIDSuccessBlock touchSuccessBlock;      // 指纹验证成功的 block
@property (nonatomic, copy) TouchIDFailBlock touchFailBlock;            // 指纹校验失败的 block

/**
 *  检测是否可以使用 touchID 功能
 *
 *  @return 判断后的结果
 */
- (BOOL)canUseTouchID;

@end
