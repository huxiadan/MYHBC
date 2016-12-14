//
//  CommHeader.h
//  HDKit
//
//  Created by 1233go on 16/7/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#ifndef CommHeader_h
#define CommHeader_h

// release版本去除控制台输出
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

// NSUserDefaults  
#define HDUserDefaults [NSUserDefaults standardUserDefaults]

// 常量
#define kTabbarHeight 49
#define kNavigationBarHeight 64


#endif /* CommHeader_h */
