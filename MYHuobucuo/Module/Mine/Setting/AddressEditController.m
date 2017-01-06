//
//  AddressEditController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/7.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AddressEditController.h"
#import "MYSingleTon.h"
#import "AddressPickerView.h"
#import "MYProgressHUD.h"
#import <Masonry.h>
#import "NetworkRequest.h"

@interface AddressEditController ()

@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, strong) AddressModel *model;


@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *infoView;         // 地址信息视图
@property (nonatomic, strong) UIView *defaultView;      // 设为默认地址视图
@property (nonatomic, strong) UIView *delCoverView;     // 删除弹窗
@property (nonatomic, strong) AddressPickerView *picker;     // 省份/城市/地区选择器


@property (nonatomic, strong) UITextField *personField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UILabel *provinceLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UITextView *addrTextView;
@property (nonatomic, strong) UIButton *defaultButton;

@end

@implementation AddressEditController

- (instancetype)initWithModel:(AddressModel *)model
{
    if (self = [super init]) {
        self.titleString = model == nil ? @"添加收货地址" : @"修改收货地址";
        self.model = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self addTitleView];
    
    [self addInfoView];
    
    [self addDefaultView];
    
    if (self.model) {
        [self addDeleteView];
    }
    
    // 赋值
    if (self.model) {
        [self.personField setText:self.model.receivePersonName];
        [self.phoneField setText:self.model.phoneNumber];
        [self.provinceLabel setText:self.model.province];
        [self.cityLabel setText:self.model.city];
        [self.areaLabel setText:self.model.area];
        [self.addrTextView setText:self.model.address];
        [self.defaultButton setSelected:self.model.isDefaultAddress];
    }
}

- (void)addDeleteView
{
    UIButton *delView = [[UIButton alloc] init];
    [delView setTitle:@"删除该地址" forState:UIControlStateNormal];
    [delView.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [delView setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    delView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [delView setTitleEdgeInsets:UIEdgeInsetsMake(0, fScreen(30), 0, 0)];
    [delView setBackgroundColor:[UIColor whiteColor]];
    [delView addTarget:self action:@selector(delAddressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delView];
    [delView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.defaultView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88));
    }];
    
}

- (void)addDefaultView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.infoView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(88));
    }];
    self.defaultView = view;
    
    UIButton *defaultButton = [[UIButton alloc] init];
    
    [defaultButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, fScreen(226 - 30))];
    
    [defaultButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [defaultButton setImage:[UIImage imageNamed:@"icon_pitch-on_s"] forState:UIControlStateSelected];
    [defaultButton setImage:[UIImage imageNamed:@"icon_pitch-on_n"] forState:UIControlStateNormal];
    [defaultButton setTitle:@"设为默认地址" forState:UIControlStateNormal];
    [defaultButton setTitle:@"设为默认地址" forState:UIControlStateSelected];
    [defaultButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateSelected];
    [defaultButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [defaultButton addTarget:self action:@selector(defaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:defaultButton];
    [defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30) + 1);
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(fScreen(206 + 20));
        make.height.mas_equalTo(fScreen(33));
    }];
    self.defaultButton = defaultButton;
}

- (void)addInfoView
{
    UIView *infoView = [[UIView alloc] init];
    [infoView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:infoView];
    [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(89*5 + 168));
    }];
    self.infoView = infoView;
    
    // 收货人
    UIView *personNameView = [self makeTextFieldCellWithTitle:@"收货人"];
    [infoView addSubview:personNameView];
    [personNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(infoView);
        make.height.mas_equalTo(fScreen(89));
    }];
    
    // 联系电话
    UIView *phoneView = [self makeTextFieldCellWithTitle:@"联系电话"];
    [infoView addSubview:phoneView];
    [phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(personNameView);
        make.top.equalTo(personNameView.mas_bottom);
    }];
    
    // 省份
    UIView *provinceView = [self makeDataPickerCellWithTitle:@"省份"];
    [infoView addSubview:provinceView];
    [provinceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(personNameView);
        make.top.equalTo(phoneView.mas_bottom);
    }];
    
    // 城市
    UIView *cityView = [self makeDataPickerCellWithTitle:@"城市"];
    [infoView addSubview:cityView];
    [cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(personNameView);
        make.top.equalTo(provinceView.mas_bottom);
    }];
    
    // 地区
    UIView *areaView = [self makeDataPickerCellWithTitle:@"地区"];
    [infoView addSubview:areaView];
    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.right.equalTo(personNameView);
        make.top.equalTo(cityView.mas_bottom);
    }];
    
    // 详细地址
    UIView *addressView = [[UIView alloc] init];
    [addressView setBackgroundColor:[UIColor whiteColor]];
    [infoView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(infoView);
        make.top.equalTo(areaView.mas_bottom);
    }];
    
    UILabel *addrLabel = [[UILabel alloc] init];
    [addrLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [addrLabel setTextColor:HexColor(0x666666)];
    [addrLabel setText:@"详细地址"];
    [addressView addSubview:addrLabel];
    [addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressView.mas_left).offset(fScreen(30));
        make.top.equalTo(addressView.mas_top).offset(fScreen(30));
        CGSize textSize = [@"详细地址" sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(textSize.width + 2);
        make.height.mas_equalTo(textSize.height);
    }];
    
    
    UITextView *addrTextView = [[UITextView alloc] init];
    [addrTextView setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [addrTextView setTextColor:HexColor(0x333333)];
    [addressView addSubview:addrTextView];
    [addrTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrLabel.mas_top).offset(-fScreen(12));
        make.left.equalTo(addrLabel.mas_right).offset(fScreen(20));
        make.right.equalTo(addressView.mas_right).offset(-fScreen(30));
        make.bottom.equalTo(addressView.mas_bottom).offset(-fScreen(20));
    }];
    self.addrTextView = addrTextView;
}

- (UIView *)makeTextFieldCellWithTitle:(NSString *)title
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [titleLabel setText:title];
    [cellView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.top.bottom.equalTo(cellView);
        CGSize textSize = [title sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(textSize.width + 2);
    }];
    
    UITextField *textField = [[UITextField alloc] init];
    [textField setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [textField setTextColor:HexColor(0x333333)];
    [textField setTintColor:HexColor(0xe44a62)];
    [cellView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cellView);
        make.right.equalTo(cellView.mas_right).offset(-fScreen(30));
        make.left.equalTo(titleLabel.mas_right).offset(fScreen(20));
    }];
    
    if ([title isEqualToString:@"收货人"]) {
        self.personField = textField;
    }
    else if ([title isEqualToString:@"联系电话"]) {
        self.phoneField = textField;
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [cellView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(cellView);
        make.height.equalTo(@1);
    }];
    
    return cellView;
}

- (UIView *)makeDataPickerCellWithTitle:(NSString *)title
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x666666)];
    [titleLabel setText:title];
    [cellView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.top.bottom.equalTo(cellView);
        CGSize textSize = [title sizeForFontsize:fScreen(28)];
        make.width.mas_equalTo(textSize.width + 2);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    [arrowImageView setImage:[UIImage imageNamed:@"icon_more2"]];
    [cellView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cellView.mas_right).offset(-fScreen(30));
        make.centerY.equalTo(cellView.mas_centerY);
        make.width.mas_equalTo(fScreen(14));
        make.height.mas_equalTo(fScreen(24));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [label setTextColor:HexColor(0x999999)];
    [cellView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-fScreen(20));
        make.top.bottom.equalTo(cellView);
        make.left.equalTo(titleLabel.mas_right).offset(fScreen(20));
    }];
    
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [cellView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(cellView);
        make.height.equalTo(@1);
    }];
    
    UIButton *button = [[UIButton alloc] init];
    [button addTarget:self action:@selector(dataPickerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(cellView);
    }];
    
    if ([title isEqualToString:@"省份"]) {
        self.provinceLabel = label;
        [button setTag:AddressDataPickerTag_Provience];
    }
    else if ([title isEqualToString:@"城市"]) {
        self. cityLabel = label;
        [button setTag:AddressDataPickerTag_City];
    }
    else if ([title isEqualToString:@"地区"]) {
        self.areaLabel = label;
        [button setTag:AddressDataPickerTag_Area];
    }
    
    return cellView;
}

- (void)addTitleView
{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88) + 20);
    }];
    self.titleView = titleView;
    
    UIButton *backButton = [self makeBackButton];
    [titleView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left);
        make.centerY.equalTo(titleView.mas_centerY).offset(10);
        make.height.mas_equalTo(fScreen(38));
        make.width.mas_equalTo(fScreen(28*2 + 38));
    }];
    
    UILabel *titleLabel = [self makeTitleLabelWithTitle:self.titleString];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    [titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backButton.mas_right).offset(-fScreen(8));
        make.top.equalTo(titleView.mas_top).offset(20);
        make.bottom.right.equalTo(titleView);
    }];
    
    UIButton *saveButton = [[UIButton alloc] init];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:saveButton];
    [saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(titleView);
        make.top.equalTo(titleView.mas_top).offset(20);
        CGSize textSize = [@"保存" sizeForFontsize:fScreen(32)];
        make.width.mas_equalTo(textSize.width + fScreen(30 * 2));
    }];
}

- (void)showDataPickerWithType:(AddressDataPickerTag)type
{
    
}


#pragma mark - button click

- (void)saveButtonClick:(UIButton *)sender
{
    // 检查数据是否完整
    if (self.personField.text.length == 0) {
        [MYProgressHUD showAlertWithMessage:@"收货人还未填写哦~"];
        [self.personField becomeFirstResponder];
        return;
    }
    else if (self.phoneField.text.length == 0) {
        [MYProgressHUD showAlertWithMessage:@"联系电话还未填写哦~"];
        [self.phoneField becomeFirstResponder];
        return;
    }
    else if (self.addrTextView.text.length == 0) {
        [MYProgressHUD showAlertWithMessage:@"详细地址还未填写哦~"];
        [self.addrTextView becomeFirstResponder];
        return;
    }
    
    AddressModel *model;
    
    if ([self.titleString rangeOfString:@"修改"].length > 0) {
        self.model.receivePersonName = self.personField.text;
        self.model.phoneNumber = self.phoneField.text;
        self.model.province = self.provinceLabel.text;
        self.model.city = self.cityLabel.text;
        self.model.area = self.areaLabel.text;
        self.model.address = self.addrTextView.text;
        if (self.defaultButton.isSelected) {
            NSArray *modelArray = [MYSingleTon sharedMYSingleTon].addressModelArray;
            for (AddressModel *model in modelArray) {
                if (model.isDefaultAddress) {
                    if (model != self.model) {
                        model.isDefaultAddress = NO;
                        self.model.isDefaultAddress = YES;
                    }
                }
            }
        }
        
        model = self.model;
    }
    else {
        model = [[AddressModel alloc] init];
        model.receivePersonName = self.personField.text;
        model.phoneNumber = self.phoneField.text;
        model.province = self.provinceLabel.text;
        model.city = self.cityLabel.text;
        model.area = self.areaLabel.text;
        model.address = self.addrTextView.text;
        if (self.defaultButton.isSelected) {
            NSArray *modelArray = [MYSingleTon sharedMYSingleTon].addressModelArray;
            for (AddressModel *fModel in modelArray) {
                if (fModel.isDefaultAddress) {
                    fModel.isDefaultAddress = NO;
                    self.model.isDefaultAddress = YES;
                }
            }
        }
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[MYSingleTon sharedMYSingleTon].addressModelArray];
        [tmpArray addObject:model];
        [MYSingleTon sharedMYSingleTon].addressModelArray = [tmpArray copy];
    }
    
    __weak typeof(self) weakSelf = self;
    
    [NetworkManager updateUserAddressWithModel:model finishBlock:^(id jsonData, NSError *error) {
        if (error) {
            DLog(@"%@",error.localizedDescription);
        }
        else {
            NSDictionary *jsonDict = (NSDictionary *)jsonData;
            NSDictionary *statusDict = jsonDict[@"status"];
            if (![statusDict[@"code"] isEqualToString:kStatusSuccessCode]) {
                [MYProgressHUD showAlertWithMessage:statusDict[@"msg"]];
            }
            else {
                [MYProgressHUD showAlertWithMessage:@"保存成功~"];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

- (void)dataPickerButtonClick:(UIButton *)sender
{
    // 取消键盘
    [self.personField resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.addrTextView resignFirstResponder];
    
    switch (sender.tag) {
        case AddressDataPickerTag_Provience:
        default:
            [self.picker showWithType:sender.tag title:self.provinceLabel.text];
            break;
        case AddressDataPickerTag_City:
            if (self.provinceLabel.text.length == 0) {
                [MYProgressHUD showAlertWithMessage:@"请先选择省份"];
                return;
            }
            [self.picker showWithType:sender.tag title:self.cityLabel.text];
            break;
        case AddressDataPickerTag_Area:
            if (self.provinceLabel.text.length == 0) {
                [MYProgressHUD showAlertWithMessage:@"请先选择省份"];
                return;
            }
            else if (self.cityLabel.text.length == 0) {
                [MYProgressHUD showAlertWithMessage:@"请先选择城市"];
                return;
            }
            [self.picker showWithType:sender.tag title:self.areaLabel.text];
            break;

    }
}

- (void)defaultButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

- (void)delAddressButtonClick:(UIButton *)sender
{
    [self.delCoverView setHidden:NO];
}

// alert button click
- (void)escButtonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.delCoverView setHidden:YES];
    }];
}

- (void)sureButtonClick:(UIButton *)sender
{
    // 删除
    __weak typeof(self) weakSelf = self;
    
    [NetworkManager deleteUserAddressWithAddressId:self.model.addressId finishBlock:^(id jsonData, NSError *error) {
        if (error) {
            DLog(@"%@",error.localizedDescription);
        }
        else {
            NSDictionary *jsonDict = (NSDictionary *)jsonData;
            NSDictionary *statusDict = jsonDict[@"status"];
            if (![statusDict[@"code"] isEqualToString:kStatusSuccessCode]) {
                [MYProgressHUD showAlertWithMessage:statusDict[@"msg"]];
            }
            else {
                [MYProgressHUD showAlertWithMessage:@"删除成功~"];
                
                NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:[MYSingleTon sharedMYSingleTon].addressModelArray];
                [tmpArray removeObject:weakSelf.model];
                [MYSingleTon sharedMYSingleTon].addressModelArray = [tmpArray copy];
                
                // 返回
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

#pragma mark - Getter
- (AddressPickerView *)picker
{
    if (!_picker) {
        _picker = [[AddressPickerView alloc] init];
        
        [_picker setinitailData:self.provinceLabel.text city:self.cityLabel.text area:self.areaLabel.text];
        
        __weak typeof(self) weakSelf = self;
        _picker.titleBlock = ^(NSString *title, AddressDataPickerTag tag) {
            if (tag == AddressDataPickerTag_Provience) {
                if (![title isEqualToString:weakSelf.provinceLabel.text]) {
                    [weakSelf.provinceLabel setText:title];
                    [weakSelf.cityLabel setText:@""];
                    [weakSelf.areaLabel setText:@""];
                }
            }
            else if (tag == AddressDataPickerTag_City) {
                if (![title isEqualToString:weakSelf.cityLabel.text]) {
                    [weakSelf.cityLabel setText:title];
                    [weakSelf.areaLabel setText:@""];
                }
            }
            else if (tag == AddressDataPickerTag_Area) {
                [weakSelf.areaLabel  setText:title];
            }
        };
        [self.view addSubview:_picker];
    }
    return _picker;
}

- (UIView *)delCoverView
{
    if (!_delCoverView) {
        _delCoverView = [[UIView alloc] init];
        [_delCoverView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3f]];
        [_delCoverView setFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_delCoverView];
        [_delCoverView setHidden:YES];
        
        UIView *alertView = [[UIView alloc] init];
        [alertView setBackgroundColor:[UIColor whiteColor]];
        [alertView.layer setCornerRadius:fScreen(26)];
        [alertView.layer setMasksToBounds:YES];
        [_delCoverView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_delCoverView.mas_top).offset(fScreen(386));
            make.width.mas_equalTo(fScreen(540));
            make.height.mas_equalTo(fScreen(288));
            make.centerX.equalTo(_delCoverView.mas_centerX);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [label setTextColor:HexColor(0x666666)];
        [label setText:@"确认要删除该地址吗?"];
        [label setTextAlignment:NSTextAlignmentCenter];
        [alertView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(alertView);
            make.height.mas_equalTo(fScreen(288 - 88));
        }];
        
        UIButton *leftButton = [[UIButton alloc] init];
        [leftButton.layer setBorderColor:viewControllerBgColor.CGColor];
        [leftButton.layer setBorderWidth:1.0f];
        [leftButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [leftButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
        [leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [leftButton setTag:0];
        [leftButton addTarget:self action:@selector(escButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:leftButton];
        [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(alertView);
            make.height.mas_equalTo(fScreen(88));
            make.width.mas_equalTo(fScreen(540/2));
        }];
        
        UIButton *rightButton = [[UIButton alloc] init];
        [rightButton.layer setBorderColor:viewControllerBgColor.CGColor];
        [rightButton.layer setBorderWidth:1.0f];
        [rightButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [rightButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateNormal];
        [rightButton setTitle:@"删除" forState:UIControlStateNormal];
        [rightButton setTag:1];
        [rightButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [alertView addSubview:rightButton];
        [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.equalTo(alertView);
            make.height.mas_equalTo(fScreen(88));
            make.width.mas_equalTo(fScreen(540/2));
        }];
    }
    return _delCoverView;
}

@end
