//
//  CategoryCollCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/10/31.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetailModel.h"

static NSString *collCellIdentity = @"categoryCollectionViewCellIdentity";

@interface CategoryCollCell : UICollectionViewCell

@property (nonatomic, strong) CategoryDetailModel *model;

@end
