//
//  AddressTabFooterView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kAddressTabFooterHeight fScreen(40*2 + 88)

typedef void(^ButtonClickBlock)();

@interface AddressTabFooterView : UIView

@property (nonatomic, strong) ButtonClickBlock clickBlock;

@end
