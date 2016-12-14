//
//  CollGoodsCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollGoodsModel.h"

static NSString *cellIdentity = @"CollectionGoodsCellIdentity";
#define kCollGoodsCellRowHeight fScreen(244)

typedef void(^CollectionButtonClickBlock)(BOOL isCollection);
typedef void(^ShareButtonClickBlock)(ShareModel *shareModel);

@interface CollGoodsCell : UITableViewCell

@property (nonatomic, strong) CollGoodsModel *model;
@property (nonatomic, copy) CollectionButtonClickBlock collectBlock;
@property (nonatomic, copy) ShareButtonClickBlock shareBlock;

@end
