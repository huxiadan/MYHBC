//
//  AddressPickerView.h
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureButtonClickBlock)(NSString *title, AddressDataPickerTag tag);

@interface AddressPickerView : UIView

@property (nonatomic, copy) SureButtonClickBlock titleBlock;

- (void)showWithType:(AddressDataPickerTag)type title:(NSString *)title;

// 设置初始的数据,用于防止地址已经存在的情况下,直接修改城市/地区导致数据源不能正确显示的问题
- (void)setinitailData:(NSString *)provinceName city:(NSString *)cityName area:(NSString *)areaName;

@end
