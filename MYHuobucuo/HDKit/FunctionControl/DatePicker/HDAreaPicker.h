//
//  HDAreaPicker.h
//  Test
//
//  Created by hudan on 16/9/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

/**
    日期选择器
 */

#import <UIKit/UIKit.h>

typedef void(^AreaChooseBlock)(NSDictionary *areaDict);

#define PickerProvinceKey @"HDProvinceKey"
#define PickerCityKey     @"HDCityKey"
#define PickerDistrictKey @"HDDistrictKey"

@interface HDAreaPicker : UIView


/**
 初始化方法

 @param frame     frame
 @param areaDict  地区信息的字典 {key:省份 value:{key: 市 value: 县/区}}
 @param complete  点击确定/返回按钮后的地址

 @return 实例化的对象
 */
- (instancetype)initWithFrame:(CGRect)frame
                     areaDict:(NSDictionary *)areaDict
                     complete:(AreaChooseBlock)complete;

- (void)show;
@end
