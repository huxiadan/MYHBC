//
//  EvaluateTabCell.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/15.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "EvaluateTabCell.h"
#import "HDStarView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>

#define kPhotoMaxNumber 4

@interface EvaluateTabCell ()

@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) HDStarView *starView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *photoView1;
@property (nonatomic, strong) UIImageView *photoView2;
@property (nonatomic, strong) UIImageView *photoView3;
@property (nonatomic, strong) UIImageView *photoView4;

@end

@implementation EvaluateTabCell

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
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [nameLabel setTextColor:HexColor(0x7f75b6)];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(28));
        make.top.equalTo(self.mas_top).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.width.equalTo(@1);
    }];
    self.userNameLabel = nameLabel;

    HDStarView *starView = [[HDStarView alloc] initWithStarNumber:5 height:fScreen(24) margin:fScreen(6)];
    [self addSubview:starView];
    [starView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(fScreen(20));
        make.top.equalTo(nameLabel.mas_top);
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(134));
    }];
    self.starView = starView;
    
    UILabel *timeLabel = [[UILabel alloc] init];
    [timeLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [timeLabel setTextColor:HexColor(0x999999)];
    [timeLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:timeLabel];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-fScreen(30));
        make.bottom.equalTo(nameLabel.mas_bottom);
        make.width.mas_equalTo(fScreen(220));
        make.height.mas_equalTo(fScreen(24));
    }];
    self.timeLabel = timeLabel;
    
    UILabel *contentLabel = [[UILabel alloc] init];
    [contentLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [contentLabel setTextColor:HexColor(0x666666)];
    [contentLabel setNumberOfLines:0];
    [contentLabel setAdjustsFontSizeToFitWidth:YES];
    [self addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(16));
        make.right.equalTo(timeLabel.mas_right);
        make.height.mas_equalTo(fScreen(24));
    }];
    self.contentLabel = contentLabel;
    
    for (NSInteger index = 0; index < kPhotoMaxNumber; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setBackgroundColor:[UIColor grayColor]];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(contentLabel.mas_bottom).offset(fScreen(16));
            make.height.mas_equalTo(fScreen(134));
            make.width.mas_equalTo(fScreen(134));
            make.left.equalTo(contentLabel.mas_left).offset(index * (fScreen(134 + 10)));
        }];
        
        switch (index) {
            case 0:
           default:
                self.photoView1 = imageView;
                break;
            case 1:
                self.photoView2 = imageView;
                break;
            case 2:
                self.photoView3 = imageView;
                break;
            case 3:
                self.photoView4 = imageView;
                break;
        }
    }
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(28));
        make.right.equalTo(self.mas_right).offset(-fScreen(28));
        make.top.equalTo(contentLabel.mas_bottom).offset(fScreen(16 + 134 + 20));
        make.height.equalTo(@1);
    }];
    self.lineView = lineView;
}

- (void)setModel:(EvaluateModel *)model
{
    _model = model;
    
    [self.userNameLabel setText:[NSString stringWithFormat:@"%@",model.userName]];
    [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        CGSize textSize = [self.userNameLabel.text sizeForFontsize:fScreen(24)];
        make.width.mas_equalTo(textSize.width);
    }];
    
    self.starView.starNumber = model.starNumber;
    [self.starView layoutIfNeeded];
    
    [self.timeLabel setText:[NSString stringWithFormat:@"%@",model.time]];
    
    [self.contentLabel setText:[NSString stringWithFormat:@"%@",model.contentText]];
    CGSize containSize = CGSizeMake(kAppWidth - fScreen(28 + 30), 10000.f);
    CGSize textSize = [self.contentLabel.text boundingRectWithSize:containSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.contentLabel.font} context:nil].size;
    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(textSize.height);
    }];
    
    [self.photoView1 layoutIfNeeded];
    [self.photoView2 layoutIfNeeded];
    [self.photoView3 layoutIfNeeded];
    [self.photoView4 layoutIfNeeded];
    
    if (model.photoArray.count > 0) {
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(fScreen(16 + 134 + 20));
        }];
        
        // 图片
        NSInteger photoCount = model.photoArray.count;
        
        for (NSInteger index = 0; index < 4; index++) {
            
            UIImage *placeholderImage = [UIImage imageNamed:@"placeholder.JPG"];
            NSString *urlString;
            if (index > photoCount - 1) {
                // 超过用户的照片数量
                urlString = nil;
            }
            else {
                urlString = [NSString stringWithFormat:@"%@",[model.photoArray objectAtIndex:index]];
            }
            
            switch (index) {
                case 0:
                    if (urlString.length > 0) {
                        [self.photoView1 sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
                        self.photoView1.hidden = NO;
                    }
                    else {
                        self.photoView1.hidden = YES;
                    }
                    break;
                case 1:
                    if (urlString.length > 0) {
                        [self.photoView2 sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
                        self.photoView2.hidden = NO;
                    }
                    else {
                        self.photoView2.hidden = YES;
                    }
                    break;
                case 2:
                    if (urlString.length > 0) {
                        [self.photoView3 sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
                        self.photoView3.hidden = NO;
                    }
                    else {
                        self.photoView3.hidden = YES;
                    }
                    break;
                case 3:
                default:
                    if (urlString.length > 0) {
                        [self.photoView4 sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
                        self.photoView4.hidden = NO;
                    }
                    else {
                        self.photoView4.hidden = YES;
                    }
                    break;
            }
        }
    }
    else {
        [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(fScreen(20));
        }];
        
        [self.photoView1 setHidden:YES];
        [self.photoView2 setHidden:YES];
        [self.photoView3 setHidden:YES];
        [self.photoView4 setHidden:YES];
    }
}

@end
