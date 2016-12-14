//
//  StoreItemButton.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/30.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    店铺中的上图下文字的 item 按钮
 */

#import <UIKit/UIKit.h>

@interface StoreItemButton : UIView

- (instancetype)initWithTitle:(NSString *)title
                    imageName:(NSString *)imageName
         heightlightImageName:(NSString *)heightlightImageName
                       target:(id)target
                       action:(SEL)action;


@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign, readonly) CGFloat height;

@end
