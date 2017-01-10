//
//  AddressPickerView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDAreaModel.h"

typedef void(^SureButtonClickBlock)(HDAreaModel *model, AddressDataPickerTag tag);

@interface AddressPickerView : UIView

@property (nonatomic, copy) SureButtonClickBlock titleBlock;

- (void)showWithType:(AddressDataPickerTag)type title:(HDAreaModel *)title;

// 设置初始的数据,用于防止地址已经存在的情况下,直接修改城市/地区导致数据源不能正确显示的问题
- (void)setinitailData:(HDAreaModel *)provinceName city:(HDAreaModel *)cityName area:(HDAreaModel *)areaName;

@end
