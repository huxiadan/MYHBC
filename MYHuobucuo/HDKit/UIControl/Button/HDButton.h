//
//  HDButton.h
//  Huobucuo
//
//  Created by hudan on 16/9/5.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger) {
    HDImageTitleNormal = 0,         // 普通:左图右文字
    HDImageTitleLeftTitle = 1,      // 文字在左边
    HDImageTitleBottomTitle = 2,    // 文字在下边
//    HDImageTitleTopTitle = 3,       // 文字在顶部
}HDImageTitle;

typedef void(^ButtonActionBlock)(UIButton *sender);

@interface HDButton : UIButton

@property (nonatomic, assign) HDImageTitle imageTitleType;

@property (nonatomic, copy) ButtonActionBlock clickBlock;


@end
