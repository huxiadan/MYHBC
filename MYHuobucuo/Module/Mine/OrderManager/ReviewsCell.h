//
//  ReviewsCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    评论 cell
 */

#import <UIKit/UIKit.h>
#import "reviewModel.h"

static NSString *cellIdentity = @"ReviewsCellIdentity";

@interface ReviewsCell : UITableViewCell

@property (nonatomic, strong) reviewModel *model;
@property (nonatomic, strong) UINavigationController *navController;

@end
