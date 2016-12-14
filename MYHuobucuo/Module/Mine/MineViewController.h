//
//  MineViewController.h
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "BaseViewController.h"

@interface MineViewController : BaseViewController

@end


// MineUserInfoButton
typedef void(^MineUserInfoButtonClickBlock)();

@interface MineUserInfoButton : UIView

@property (nonatomic, copy) NSString *number;
- (void)setNumber:(NSString *)numberStr buttonType:(MineUserInfoButtonType)type;
@property (nonatomic, copy) MineUserInfoButtonClickBlock clickBlock;

@end


// MineOrderButton
typedef void(^MineOrderButtonClickBlock)(NSString *buttonName);

@interface MineOrderButton : UIView

- (instancetype)initWithType:(NSString *)title;
@property (nonatomic, copy) MineOrderButtonClickBlock clickBlock;

@end
