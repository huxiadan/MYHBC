//
//  BillCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    账单 cell
 */

#import <UIKit/UIKit.h>
#import "BillModel.h"

static NSString *cellIdentity = @"BillCellIdentity";

@interface BillCell : UITableViewCell

@property (nonatomic, strong) BillModel *billModel;

@end
