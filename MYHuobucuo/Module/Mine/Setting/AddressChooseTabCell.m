//
//  AddressChooseTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/19.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "AddressChooseTabCell.h"
#import <Masonry.h>

@interface AddressChooseTabCell ()

@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextView *addresssLabel;
@property (nonatomic, strong) UIButton *defaultButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation AddressChooseTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // line
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(fScreen(20));
    }];
    
    // 选择
    UIButton *selectButton = [[UIButton alloc] init];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_n"] forState:UIControlStateNormal];
    [selectButton setImage:[UIImage imageNamed:@"icon_choose_s"] forState:UIControlStateSelected];
    [selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectButton];
    [selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.top.equalTo(lineView.mas_bottom);
        make.width.mas_equalTo(fScreen(100));
    }];
    self.selectButton = selectButton;
    
    // 名字
    CGSize phoneSize = [@"01234567890" sizeForFontsize:fScreen(24)];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton.mas_right).offset(fScreen(30));
        make.top.equalTo(self.mas_top).offset(fScreen(30));
        make.right.equalTo(self.mas_right).offset(-fScreen(30 + phoneSize.width + 2));
        CGSize textSize = [@"" sizeForFontsize:fScreen(28)];
        make.height.mas_equalTo(textSize.height);
    }];
    self.nameLabel = nameLabel;
    
    // 电话
    UILabel *phoneLabel = [[UILabel alloc] init];
    [phoneLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [phoneLabel setTextColor:HexColor(0x333333)];
    [phoneLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:phoneLabel];
    [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-fScreen(30));
        make.centerY.equalTo(nameLabel.mas_centerY);
        make.height.mas_equalTo(phoneSize.height);
        make.width.mas_equalTo(phoneSize.width + 2);
    }];
    self.phoneLabel = phoneLabel;
    
    // 设为默认地址
    UIButton *defaultButton = [[UIButton alloc] init];
    
    [defaultButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, fScreen(206 - 30))];
    
    [defaultButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [defaultButton setImage:[UIImage imageNamed:@"icon_pitch-on_s"] forState:UIControlStateSelected];
    [defaultButton setImage:[UIImage imageNamed:@"icon_pitch-on_n"] forState:UIControlStateNormal];
    [defaultButton setTitle:@"设为默认地址" forState:UIControlStateNormal];
    [defaultButton setTitle:@"设为默认地址" forState:UIControlStateSelected];
    [defaultButton setTitleColor:HexColor(0xe44a62) forState:UIControlStateSelected];
    [defaultButton setTitleColor:HexColor(0x999999) forState:UIControlStateNormal];
    [defaultButton addTarget:self action:@selector(defaultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defaultButton];
    [defaultButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(selectButton.mas_right).offset(fScreen(30) + 1);
        make.bottom.equalTo(self.mas_bottom).offset(-fScreen(20));
        make.width.mas_equalTo(fScreen(206));
        make.height.mas_equalTo(fScreen(30));
    }];
    self.defaultButton = defaultButton;
    
    // 地址
    UITextView *addressLabel = [[UITextView alloc] init];
    [addressLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [addressLabel setTextColor:HexColor(0x333333)];
    [addressLabel setUserInteractionEnabled:NO];
    [addressLabel setContentInset:UIEdgeInsetsMake(-10, -5, 0, 20)];
    [self addSubview:addressLabel];
    [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(30));
        make.bottom.equalTo(defaultButton.mas_top).offset(-fScreen(30));
        make.right.equalTo(phoneLabel.mas_right).offset(fScreen(20));
    }];
    self.addresssLabel = addressLabel;
    
//    // 箭头
//    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more1"]];
//    [self addSubview:arrowImageView];
//    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(fScreen(-fScreen(30)));
//        make.width.mas_equalTo(fScreen(20));
//        make.height.mas_equalTo(fScreen(40));
//        make.centerY.equalTo(self.mas_centerY).offset(fScreen(20));
//    }];
//    
//    
//    // 删除按钮
//    UIButton *deleteButton = [[UIButton alloc] init];
//    [deleteButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
//    [deleteButton setTitle:@"删\n除" forState:UIControlStateNormal];
//    [deleteButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
//    [deleteButton.titleLabel setTextColor:[UIColor whiteColor]];
//    [deleteButton setBackgroundColor:HexColor(0xe44a62)];
//    [deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:deleteButton];
//    [deleteButton setFrame:CGRectMake(kAppWidth, fScreen(20), fScreen(118), kAddressTabCellHeight - fScreen(20))];
//    self.deleteButton = deleteButton;
//    
//    // 添加滑动手势
//    UISwipeGestureRecognizer *swipeLetf = [[UISwipeGestureRecognizer alloc] init];
//    swipeLetf.direction = UISwipeGestureRecognizerDirectionLeft;
//    [swipeLetf addTarget:self action:@selector(showDeleteButton:)];
//    [self addGestureRecognizer:swipeLetf];
//    
//    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] init];
//    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//    [swipeRight addTarget:self action:@selector(hideDeleteButton:)];
//    [self addGestureRecognizer:swipeRight];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    [self hideDeleteButton:nil];
}

- (void)setAddrModel:(AddressModel *)addrModel
{
    _addrModel = addrModel;
    
    [self.nameLabel setText:addrModel.receivePersonName];
    [self.phoneLabel setText:addrModel.phoneNumber];
    self.defaultButton.selected = addrModel.isDefaultAddress;
    self.selectButton.selected = addrModel.isSelect;
    
    [self.addresssLabel setText:[NSString stringWithFormat:@"%@%@%@%@",
                                 addrModel.province.length == 0 ? @"" : addrModel.province,
                                 addrModel.city.length == 0 ? @"" : addrModel.city,
                                 addrModel.area.length == 0 ? @"" : addrModel.area,
                                 addrModel.address]];
}

- (void)defaultButtonClick:(UIButton *)sender
{
    self.defaultButton.selected = YES;      // 有且只有一个,所以点击永远是选中
    
    self.addrModel.isDefaultAddress = YES;
    
    // 更新其他模型为非默认地址
    NSArray *addrArray = [MYSingleTon sharedMYSingleTon].addressModelArray;
    for (AddressModel *addrModel in addrArray) {
        if (addrModel != self.addrModel) {
            addrModel.isDefaultAddress = NO;
        }
    }
    
    if (self.defaultBlock) {
        self.defaultBlock();
    }
}

- (void)deleteButtonClick:(UIButton *)sender
{
    if (self.deleteBlock) {
        self.deleteBlock(self.addrModel);
    }
}

- (void)showDeleteButton:(UIGestureRecognizer *)sender
{
    CGRect frame = self.deleteButton.frame;
    frame.origin.x -= self.deleteButton.frame.size.width;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.deleteButton setFrame:frame];
    }];
}

- (void)hideDeleteButton:(UIGestureRecognizer *)sender
{
    CGRect frame = self.deleteButton.frame;
    frame.origin.x = kAppWidth;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.deleteButton setFrame:frame];
    }];
}

- (void)selectButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    self.addrModel.isSelect = sender.isSelected;
    
    [MYSingleTon sharedMYSingleTon].currAdressModel = self.addrModel;
    
    NSArray *addrArray = [MYSingleTon sharedMYSingleTon].addressModelArray;
    for (AddressModel *addrModel in addrArray) {
        if (addrModel != self.addrModel) {
            addrModel.isSelect = NO;
        }
    }
    
    if (self.selectBlock) {
        self.selectBlock(self.addrModel);
    }
}

@end
