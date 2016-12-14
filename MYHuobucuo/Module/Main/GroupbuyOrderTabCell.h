//
//  GroupbuyOrderTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupbuyOrderModel.h"

static NSString *GroupbuyOrderTabCellIdentity = @"GroupbuyOrderTabCellIdentity";

@interface GroupbuyOrderTabCell : UITableViewCell

@property (nonatomic, strong) GroupMemberModel *model;

@end


@interface GroupbuyOrderTabHeader : UIView

@property (nonatomic, strong) GroupMemberModel *model;

@end
