//
//  HDAreaPicker.m
//  Test
//
//  Created by hudan on 16/9/26.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "HDAreaPicker.h"

#define HDPickerButtonWidth  60
#define HDPickerButtonHeight 40

@interface HDAreaPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;

@property (nonatomic, copy) AreaChooseBlock completeBlock;

@property (nonatomic, strong) NSArray *provinceArray;       // 省份
@property (nonatomic, strong) NSDictionary *cityDict;       // 城市  key: 省 -- value: 城市
@property (nonatomic, strong) NSDictionary *districtDict;   // 区/县 key: 市 -- value: 区/县

@property (nonatomic, strong) NSString *currentProvince;
@property (nonatomic, strong) NSString *currentCity;
@property (nonatomic, strong) NSString *currentDistrict;

@property (nonatomic, strong) NSDictionary *lastResultDict; // 上次选择的结果

@end

@implementation HDAreaPicker

- (void)show
{
    if (self.hidden) {
        self.hidden = NO;
    }
}

- (instancetype)initWithFrame:(CGRect)frame
                     areaDict:(NSDictionary *)areaDict
                     complete:(AreaChooseBlock)complete
{
    if (self = [super initWithFrame:frame]) {
        self.provinceArray = (NSArray *)[areaDict objectForKey:PickerProvinceKey];
        self.cityDict      = (NSDictionary *)[areaDict objectForKey:PickerCityKey];
        self.districtDict  = (NSDictionary *)[areaDict objectForKey:PickerDistrictKey];
        
        self.currentProvince = [self.provinceArray objectAtIndex:0];
        
        self.completeBlock = complete;
        
        self.picker.dataSource = self;
        self.picker.delegate   = self;
        
        CGFloat buttonWidth = HDPickerButtonWidth;
        CGFloat buttonHeight = HDPickerButtonHeight;
        
        // 确定按钮
        UIButton *sureButton = [[UIButton alloc] init];
        CGRect sureButtonFrame = CGRectMake(self.frame.size.width - buttonWidth, 0, buttonWidth, buttonHeight);

        [sureButton setFrame:sureButtonFrame];
        [sureButton setTitle:@"确定" forState: UIControlStateNormal];
        [sureButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:sureButton];
        
        // 取消按钮
        UIButton *cancelButton = [[UIButton alloc] init];
        CGRect cancelButtonFrame = CGRectMake(0, 0, buttonWidth, buttonHeight);
        
        [cancelButton setFrame:cancelButtonFrame];
        [cancelButton setTitle:@"取消" forState: UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:cancelButton];
        
    }
    return self;
}

// 关闭按钮点击
- (void)cancelButtonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.lastResultDict) {
            if (self.completeBlock) {
                self.completeBlock(self.lastResultDict);
            }
        }
        
        [self setHidden:YES];
        self.alpha = 1;
    }];
}

// 确定按钮点击
- (void)sureButtonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        NSDictionary *dict = @{PickerProvinceKey : self.currentProvince,
                               PickerCityKey     : self.currentCity,
                               PickerDistrictKey : self.currentDistrict};
        
        if (self.completeBlock) {
            self.completeBlock(dict);
        }
        
        self.lastResultDict = [dict copy];
        
        [self setHidden:YES];
        self.alpha = 1;
    }];
}

#pragma mark pickerView dataSource & delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.provinceArray count];
    }
    else if (component == 1) {
        NSArray *cityArray = [self.cityDict objectForKey:self.currentProvince];
        self.currentCity = [cityArray objectAtIndex:0];
        return [cityArray count];
    }
    else {
        NSArray *districtArray = [self.districtDict objectForKey:self.currentCity];
        self.currentDistrict = [districtArray objectAtIndex:0];
        return [districtArray count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    }
    else if (component == 1) {
        return [((NSArray *)[self.cityDict objectForKey:self.currentProvince]) objectAtIndex:row];
    }
    else {
        return [((NSArray *)[self.districtDict objectForKey:self.currentCity]) objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.currentProvince = [self.provinceArray objectAtIndex:row];
        
        [self.picker reloadComponent:1];
        [self.picker reloadComponent:2];
        
        [self.picker selectRow:0 inComponent:1 animated:NO];
        [self.picker selectRow:0 inComponent:2 animated:NO];
    }
    else if (component == 1) {
        self.currentCity = [((NSArray *)[self.cityDict objectForKey:self.currentProvince]) objectAtIndex:row];
        
        [self.picker reloadComponent:2];
        
        [self.picker selectRow:0 inComponent:2 animated:NO];
    }
    else {
        self.currentDistrict = [((NSArray *)[self.districtDict objectForKey:self.currentCity]) objectAtIndex:row];
    }
}

#pragma mark - Getter
- (UIPickerView *)picker
{
    if (!_picker) {
        CGRect frame = self.frame;
        frame.origin.y = HDPickerButtonHeight;
        frame.size.height -= HDPickerButtonHeight;
        _picker = [[UIPickerView alloc] initWithFrame:frame];
        
        [self addSubview:_picker];
    }
    return _picker;
}

@end
