//
//  GroupbuyOrderTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupbuyOrderTabCell.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "ToolSingleton.h"

@interface GroupbuyOrderTabCell ()

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GroupbuyOrderTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initUI
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:HexColor(0xf7f7f7)];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(10));
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-fScreen(10));
        make.height.mas_equalTo(fScreen(90));
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView.layer setCornerRadius:fScreen(70/2)];
    [imageView.layer setBorderColor:HexColor(0xcecece).CGColor];
    [imageView.layer setBorderWidth:fScreen(3)];
    [contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(fScreen(10));
        make.centerY.equalTo(contentView);
        make.height.width.mas_equalTo(fScreen(70));
    }];
    self.userIcon = imageView;
    
    UILabel *identityLabel = [[UILabel alloc] init];
    [identityLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [identityLabel setTextColor:HexColor(0x333333)];
    [identityLabel setText:@"团员"];
    [contentView addSubview:identityLabel];
    [identityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(10));
        make.centerY.equalTo(contentView);
        make.height.mas_equalTo(fScreen(26));
        make.width.mas_equalTo(fScreen(26*2) + 2);
    }];
//    self.userIdentityLabel = identityLabel;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(identityLabel.mas_right).offset(fScreen(10));
        make.centerY.equalTo(contentView);
        make.height.mas_equalTo(fScreen(26));
        make.right.equalTo(contentView.mas_centerX);
    }];
    self.userNameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [timeLabel setTextColor:HexColor(0x999999)];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-fScreen(10));
        make.height.mas_equalTo(fScreen(24));
        make.left.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView);
    }];
    self.timeLabel = timeLabel;
}

- (void)setModel:(GroupMemberModel *)model
{
    if (model.userIconUrl.length == 0) {
        [self.userIcon setImage:[UIImage imageNamed:@"img_boy"]];
    }
    else {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    }
    
    [self.userNameLabel setText:model.userName];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@ 参团",[self timeToString:model.addTime]]];
}

// 时间戳转字符串
- (NSString *)timeToString:(NSUInteger)time
{
    NSString *timeString = [NSString stringWithFormat:@"%ld",time];
    
    NSInteger num = [timeString integerValue]/1000;
    
    NSDateFormatter *formatter = fShareToolInstance.dateFormatter;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

@end



#pragma mark - header

@interface GroupbuyOrderTabHeader ()

@property (nonatomic, strong) UIImageView *userIcon;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation GroupbuyOrderTabHeader

- (instancetype)init
{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self.layer setBorderColor:[UIColor clearColor].CGColor];
    
    UIView *contentView = [[UIView alloc] init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(10));
        make.top.equalTo(self);
        make.right.equalTo(self).offset(-fScreen(10));
        make.height.mas_equalTo(fScreen(90));
    }];
    
    // 虚线边框
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = viewControllerBgColor.CGColor;
    border.fillColor = nil;
    CGRect frame = CGRectMake(0, 0.5, kAppWidth - fScreen(20 + 10)*2, fScreen(90));
    border.path = [UIBezierPath bezierPathWithRect:frame].CGPath;
    border.frame = frame;
    border.lineWidth = 1.0f;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @3];
    [contentView.layer addSublayer:border];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView.layer setCornerRadius:fScreen(70/2)];
    [imageView.layer setBorderColor:HexColor(0xcecece).CGColor];
    [imageView.layer setBorderWidth:fScreen(3)];
    [contentView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(fScreen(10));
        make.centerY.equalTo(contentView);
        make.height.width.mas_equalTo(fScreen(70));
    }];
    self.userIcon = imageView;
    
    UILabel *identityLabel = [[UILabel alloc] init];
    [identityLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [identityLabel setTextColor:HexColor(0x333333)];
    [identityLabel setText:@"团长"];
    [contentView addSubview:identityLabel];
    [identityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_right).offset(fScreen(10));
        make.centerY.equalTo(contentView);
        make.height.mas_equalTo(fScreen(26));
        make.width.mas_equalTo(fScreen(26*2) + 2);
    }];
    //    self.userIdentityLabel = identityLabel;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(identityLabel.mas_right).offset(fScreen(10));
        make.centerY.equalTo(contentView);
        make.height.mas_equalTo(fScreen(26));
        make.right.equalTo(contentView.mas_centerX);
    }];
    self.userNameLabel = nameLabel;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [timeLabel setTextColor:HexColor(0x999999)];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [contentView addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).offset(-fScreen(10));
        make.height.mas_equalTo(fScreen(24));
        make.left.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView);
    }];
    self.timeLabel = timeLabel;
}

- (void)setModel:(GroupMemberModel *)model
{
    if (model.userIconUrl.length == 0) {
        [self.userIcon setImage:[UIImage imageNamed:@"img_boy"]];
    }
    else {
        [self.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
    }
    
    [self.userNameLabel setText:model.userName];
    [self.timeLabel setText:[NSString stringWithFormat:@"%@ 开团",[self timeToString:model.addTime]]];
}

// 时间戳转字符串
- (NSString *)timeToString:(NSUInteger)time
{
    NSString *timeString = [NSString stringWithFormat:@"%ld",time];
    
    NSInteger num = [timeString integerValue]/1000;
    
    NSDateFormatter *formatter = fShareToolInstance.dateFormatter;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:num];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

@end
