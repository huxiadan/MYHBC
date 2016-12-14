//
//  CollShopCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollShopModel.h"

static NSString *cellIdentity = @"CollectionShopCellIdentity";
#define kCollShopCellRowHeight fScreen(168)

typedef void(^CollectionButtonClickBlock)(BOOL isCollection);
typedef void(^ShareButtonClickBlock)(ShareModel *shareModel);

@interface CollShopCell : UITableViewCell

@property (nonatomic, strong) CollShopModel *model;
@property (nonatomic, copy) CollectionButtonClickBlock collectBlock;
@property (nonatomic, copy) ShareButtonClickBlock shareBlock;

@end
