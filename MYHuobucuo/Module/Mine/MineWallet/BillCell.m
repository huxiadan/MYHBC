//
//  BillCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "BillCell.h"
#import <Masonry.h>

@interface BillCell ()

@property (nonatomic, strong) UILabel *typeNameLabel;       // 类型名称
@property (nonatomic, strong) UILabel *dateLabel;           // 时间
@property (nonatomic, strong) UILabel *amountLabel;         // 收入

@end

@implementation BillCell

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
    
    UILabel *typeLabel = [[UILabel alloc] init];
    [typeLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [typeLabel setTextColor:HexColor(0x666666)];
    [self addSubview:typeLabel];
    [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(30));
        make.top.equalTo(self).offset(fScreen(28));
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(200));
    }];
    self.typeNameLabel = typeLabel;
    
    UILabel *dateLabel = [[UILabel alloc] init];
    [dateLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [dateLabel setTextColor:HexColor(0x999999)];
    [self addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(30));
        make.bottom.equalTo(self).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(20));
        make.width.mas_equalTo(fScreen(200));
    }];
    self.dateLabel = dateLabel;
    
    UILabel *amountLabel = [[UILabel alloc] init];
    [amountLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
    [amountLabel setTextColor:HexColor(0xe44a62)];
    [amountLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-fScreen(30));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(fScreen(36));
        make.width.mas_equalTo(fScreen(200));
    }];
    self.amountLabel = amountLabel;
    
    UIView *line = [[UIView alloc] init];
    [line setBackgroundColor:viewControllerBgColor];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(fScreen(2));
    }];
}

- (void)setBillModel:(BillModel *)billModel
{
    _billModel = billModel;
    
    NSString *typeString;
    switch (billModel.billType) {
        case BillType_BySelf:
        default:
            typeString = @"自营收入";
            break;
        case BillType_ByTeam:
            typeString = @"团队收款";
            break;
        case BillType_ByDelegate:
            typeString = @"代销收入";
            break;
    }
    [self.typeNameLabel setText:typeString];
    
    [self.dateLabel setText:billModel.billDate];
    
    [self.amountLabel setText:[NSString stringWithFormat:@"¥ %@", billModel.billAmount]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
