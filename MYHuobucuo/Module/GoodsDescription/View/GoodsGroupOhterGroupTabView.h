//
//  GoodsGroupOhterGroupTabView.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    其他团购推荐
 */

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"

//typedef void(^OtherGroupSelectBlock)(NSString *groupId, NSString *title);

@interface GoodsGroupOhterGroupTabView : UITableView

//@property (nonatomic, copy) OtherGroupSelectBlock otherSelectBlock;

@property (nonatomic, strong) UINavigationController *navController;

- (instancetype)initWithData:(NSArray *)dataList;

- (void)endTimer;

@end


#pragma mark - cell
@interface GoodsGroupOhterGroupTabCell : UITableViewCell

@property (nonatomic, strong) OtherGroupModel *model;
@property (nonatomic, assign) NSInteger time;

@end

#pragma mark - header

@interface GoodsGroupOhterGroupTabHeader : UIView

@end
