//
//  GroupbuyTabHeaderView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

typedef void(^GroupbuyTabHeaderClickBlock)(NSInteger );

@interface GroupbuyTabHeaderView : UIView

@property (nonatomic, strong) NSArray<BannerModel *> *imagesArray;
@property (nonatomic, copy) GroupbuyTabHeaderClickBlock clickBlock;

@end
