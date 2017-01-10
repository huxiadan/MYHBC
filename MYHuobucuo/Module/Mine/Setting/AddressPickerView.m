//
//  AddressPickerView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/8.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AddressPickerView.h"
#import <Masonry.h>

@interface AddressPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray<HDAreaModel *> *provinceNameArray;   // 省份名称数组
@property (nonatomic, strong) NSArray<HDAreaModel *> *cityNameArray;       // 城市名称数组
@property (nonatomic, strong) NSArray<HDAreaModel *> *areaNameArray;       // 地区名称数组

@property (nonatomic, strong) NSArray *provinceArray;       // 省份数组(包含城市/地区)
@property (nonatomic, strong) NSArray *cityArray;           // 城市数组(包含地区)


@property (nonatomic, copy)  HDAreaModel *currAreaModel;    // 当前 picker 的模型

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, assign) AddressDataPickerTag pickerTag;

@end

@implementation AddressPickerView

- (instancetype)init
{
    if (self = [super init]) {
        [self initData];
        
        [self initUI];
    }
    return self;
}

- (void)initData
{
    // 读取 plist 文件内容
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"address.plist" ofType:nil];
    NSArray *areaArray = [NSArray arrayWithContentsOfFile:filePath];

    NSMutableArray *tmpProvArray = [NSMutableArray array];
    for (NSDictionary *provDict in areaArray) {
        NSArray *provCodeArray = [[NSString stringWithFormat:@"%@", provDict[@"name"]] componentsSeparatedByString:@","];
        HDAreaModel *areaModel = [[HDAreaModel alloc] init];
        [areaModel setValueWithArray:provCodeArray];
        [tmpProvArray addObject:areaModel];
    }

    self.provinceNameArray = [tmpProvArray copy];
    self.provinceArray = [areaArray copy];
    
    // 第一次默认数据
    [self getCityArrayWithProvince:self.provinceNameArray[0]];
    [self getAreaArrayWithCity:self.cityNameArray[0]];
}

// 根据省份获取城市数组
- (void)getCityArrayWithProvince:(HDAreaModel *)provinceName
{
    // 遍历省份
    for (NSDictionary *dict in self.provinceArray) {
        
        NSString *compareName = [NSString stringWithFormat:@"%@", dict[@"name"]];
        NSArray *cmpArray = [compareName componentsSeparatedByString:@","];
        
        if ([provinceName.areaName isEqualToString:[cmpArray objectAtIndex:1]]) {
            NSArray *cityArray = dict[@"sub"];
            
            // 遍历该省份的城市数组
            NSMutableArray *tmpCityArray = [NSMutableArray arrayWithCapacity:cityArray.count];
            for (NSDictionary *cityDict in cityArray) {
                
                HDAreaModel *model = [[HDAreaModel alloc] init];
                [model setValueWithArray:[[NSString stringWithFormat:@"%@",cityDict[@"name"]] componentsSeparatedByString:@","]];
                
                [tmpCityArray addObject:model];
            }
            self.cityNameArray = [tmpCityArray copy];
            self.cityArray = cityArray;
            return;
        }
    }
}

// 根据城市获取地区数组
- (void)getAreaArrayWithCity:(HDAreaModel *)cityName
{
    for (NSDictionary *cityDict in self.cityArray) {
        
        NSString *compareName = [NSString stringWithFormat:@"%@", cityDict[@"name"]];
        NSArray *cmpArray = [compareName componentsSeparatedByString:@","];
        
        if ([cityName.areaName isEqualToString:[cmpArray objectAtIndex:1]]) {
            
            NSArray *tmpAreaArray = cityDict[@"sub"];
            NSMutableArray *mTmpAreaArray = [NSMutableArray arrayWithCapacity:tmpAreaArray.count];
            
            for (NSString *areaString in tmpAreaArray) {
                
                NSArray *array = [areaString componentsSeparatedByString:@","];
                HDAreaModel *model = [[HDAreaModel alloc] init];
                [model setValueWithArray:array];
                [mTmpAreaArray addObject:model];
            }
            
            self.areaNameArray = [mTmpAreaArray copy];
            return;
        }
    }
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    [self setFrame:[UIScreen mainScreen].bounds];
    self.alpha = 0;
    self.hidden = YES;
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(fScreen(600));
    }];
    
    UIButton *coverButton = [[UIButton alloc] init];
    [coverButton addTarget:self action:@selector(coverClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:coverButton];
    [coverButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.bottom.equalTo(contentView.mas_top);
    }];
    
    UIButton *escButton = [[UIButton alloc] init];
    [escButton setTitle:@"取消" forState:UIControlStateNormal];
    [escButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [escButton addTarget:self action:@selector(escButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:escButton];
    [escButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    UIButton *sureButton = [[UIButton alloc] init];
    [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:sureButton];
    [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
    UIPickerView *picker = [[UIPickerView alloc] init];
    picker.dataSource = self;
    picker.delegate = self;
    [self addSubview:picker];
    [picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(sureButton.mas_bottom).offset(fScreen(20));
    }];
    
    self.picker = picker;
}

- (void)hide
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)showWithType:(AddressDataPickerTag)type title:(HDAreaModel *)title
{
    [self setSelectedRowWithType:type title:title];
    
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}

- (void)setSelectedRowWithType:(AddressDataPickerTag)type title:(HDAreaModel *)title
{
    self.pickerTag = type;
    [self.picker reloadAllComponents];
    
    if (title.areaName.length > 0) {
        self.currAreaModel = title;
        
        switch (type) {
            case AddressDataPickerTag_Provience:
            default:
            {
                [self setPickerSelectWithTitle:title array:self.provinceNameArray];
                // 城市/地区的数据源更改
                [self getCityArrayWithProvince:title];
                
                HDAreaModel *model = [[HDAreaModel alloc] init];
                [model setValueWithArray:[[self.cityArray[0] objectForKey:@"name"] componentsSeparatedByString:@","]];
                [self getAreaArrayWithCity:model];
            }
                break;
            case AddressDataPickerTag_City:
                [self setPickerSelectWithTitle:title array:self.cityNameArray];
                // 地区的数据源更改
                [self getAreaArrayWithCity:title];
                break;
            case AddressDataPickerTag_Area:
                [self setPickerSelectWithTitle:title array:self.areaNameArray];
                break;
        }
    }
}


- (void)setinitailData:(HDAreaModel *)provinceName city:(HDAreaModel *)cityName area:(HDAreaModel *)areaName
{
    if (provinceName.areaName.length > 0) {
        [self setSelectedRowWithType:AddressDataPickerTag_Provience title:provinceName];
        
        if (cityName.areaName.length > 0) {
            [self setSelectedRowWithType:AddressDataPickerTag_City title:cityName];
            
            if (areaName.areaName.length > 0) {
                [self setSelectedRowWithType:AddressDataPickerTag_Area title:areaName];
            }
        }
    }
}

- (void)setPickerSelectWithTitle:(HDAreaModel *)title array:(NSArray *)array
{
    NSInteger index = 0;
    
    for (HDAreaModel *subTitle in array) {
        if ([title.areaName isEqualToString:subTitle.areaName]) {
            [self.picker selectRow:index inComponent:0 animated:NO];
            break;
        }
        index++;
    }
}

#pragma mark - button click
- (void)coverClick:(UIButton *)sender
{
    [self hide];
}

- (void)escButtonClick:(UIButton *)sender
{
    [self hide];
}

- (void)sureButtonClick:(UIButton *)sender
{
    // 更改数据源
    if (self.pickerTag == AddressDataPickerTag_Provience) {
        // 更新城市和地区数组
        [self getCityArrayWithProvince:self.currAreaModel];
        // 地区默认根据第一个城市获取
        [self getAreaArrayWithCity:self.cityNameArray[0]];
    }
    else if (self.pickerTag == AddressDataPickerTag_City) {
        // 更新地区数组
        [self getAreaArrayWithCity:self.currAreaModel];
    }
    
    if (self.currAreaModel.areaName.length == 0) {
        if (self.pickerTag == AddressDataPickerTag_Provience) {
            self.currAreaModel = self.provinceNameArray[0];
        }
        else if (self.pickerTag == AddressDataPickerTag_City) {
            self.currAreaModel = self.cityNameArray[0];
        }
        else if (self.pickerTag == AddressDataPickerTag_Area) {
            self.currAreaModel = self.areaNameArray[0];
        }
    }
    
    if (self.titleBlock) {
        self.titleBlock(self.currAreaModel, self.pickerTag);
    }
    
    [self hide];
}

#pragma mark pickerView dataSource & delegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.pickerTag) {
        case AddressDataPickerTag_Provience:
            default:
            return [self.provinceNameArray count];
            break;
        case AddressDataPickerTag_City:
            return [self.cityNameArray count];
            break;
        case AddressDataPickerTag_Area:
            return [self.areaNameArray count];
            break; 
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    HDAreaModel *model = nil;
    
    switch (self.pickerTag) {
        case AddressDataPickerTag_Provience:
        default:
            model = [self.provinceNameArray objectAtIndex:row];
            break;
        case AddressDataPickerTag_City:
            model = [self.cityNameArray objectAtIndex:row];
            break;
        case AddressDataPickerTag_Area:
            model = [self.areaNameArray objectAtIndex:row];
            break;
    }
    
    return model.areaName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.pickerTag) {
        case AddressDataPickerTag_Provience:
        default:
            self.currAreaModel = [self.provinceNameArray objectAtIndex:row];
            break;
        case AddressDataPickerTag_City:
            self.currAreaModel = [self.cityNameArray objectAtIndex:row];
            break;
        case AddressDataPickerTag_Area:
            self.currAreaModel = [self.areaNameArray objectAtIndex:row];
            break;
    }
}

#pragma mark - Getter

- (AddressDataPickerTag)pickerTag
{
    if (_pickerTag == 0) {
        _pickerTag = AddressDataPickerTag_Provience;   // 默认是省份
    }
    return _pickerTag;
}

//- (NSArray<HDAreaModel *> *)cityNameArray
//{
//    if (!_cityNameArray) {
//        _cityNameArray = self getCityArrayWithProvince:
//    }
//    return _cityNameArray;
//}



@end
