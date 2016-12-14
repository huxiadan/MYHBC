//
//  EvaluateTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    评价的 cell
 */

#import <UIKit/UIKit.h>
#import "EvaluateModel.h"

static NSString *cellIdentity = @"EvaluateTabCellIdentity";

@interface EvaluateTabCell : UITableViewCell

@property (nonatomic, strong) EvaluateModel *model;

@end
