//
//  MainModelCollHeader.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/10.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModelHeaderModel.h"

static NSString *collHeaderViewIdentity = @"mainModelCollHeaderViewIdentity";

@interface MainModelCollHeader : UICollectionReusableView

@property (nonatomic, strong) MainModelHeaderModel *model;

@end
