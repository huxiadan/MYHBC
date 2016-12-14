//
//  CategoryDockCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/28.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryDockModel.h"

#define kCategoryDockCellHeight fScreen(88)
static NSString *cellIdentitiiy = @"CategoryDockCellIdentity";

@interface CategoryDockCell : UITableViewCell

@property (nonatomic, strong) CategoryDockModel *model;
@property (nonatomic, strong) UIView *selectLineView;

@end
