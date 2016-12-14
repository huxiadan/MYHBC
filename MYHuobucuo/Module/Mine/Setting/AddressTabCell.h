//
//  AddressTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

static NSString *cellIdentity = @"AddressTabCellIdentity";
#define kAddressTabCellHeight fScreen(258)

typedef void(^DeleteButtonClickBlock)(AddressModel *model);

@interface AddressTabCell : UITableViewCell

@property (nonatomic, strong) AddressModel *addrModel;
@property (nonatomic, copy) DeleteButtonClickBlock deleteBlock;

@end
