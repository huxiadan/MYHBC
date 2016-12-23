//
//  AddressChooseTabCell.h
//  MYHuobucuo
//
//  Created by hudan on 16/12/19.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    选择地址的 tableViewCell
 */

#import <UIKit/UIKit.h>
#import "AddressModel.h"

static NSString *cellIdentity = @"AddressChooseTabCellIdentity";
#define kAddressTabCellHeight fScreen(258)

typedef void(^DeleteButtonClickBlock)(AddressModel *model);
typedef void(^SetDefaultAddrBlock)();
typedef void(^AddressChooseCellSelectBlock)(AddressModel *model);

@interface AddressChooseTabCell : UITableViewCell

@property (nonatomic, strong) AddressModel *addrModel;
@property (nonatomic, copy) DeleteButtonClickBlock deleteBlock;
@property (nonatomic, copy) SetDefaultAddrBlock defaultBlock;
@property (nonatomic, copy) AddressChooseCellSelectBlock selectBlock;

@end
