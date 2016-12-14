//
//  ShareModel.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property (nonatomic, copy) NSString *shareTitle;       // 分享标题
@property (nonatomic, copy) NSString *shareImageURL;    // 分享图片地址
@property (nonatomic, copy) NSString *shareContent;     // 分享内容
@property (nonatomic, copy) NSString *shareURL;         // 分享链接

@end
