//
//  MineGroupOrderDetailTabFooterView.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/12.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MineGroupOrderDetailTabFooterView.h"
#import <Masonry.h>
#import "HDLabel.h"


@implementation MineGroupOrderDetailTabFooterView

- (instancetype)initWithNote:(NSString *)note
                       count:(NSUInteger)count
                         pay:(NSString *)pay
                     isMster:(BOOL)isMaster
{
    if (self = [super init]) {
        [self initUIWithNote:note count:count pay:pay isMaster:isMaster];
    }
    return self;
}

- (void)initUIWithNote:(NSString *)note count:(NSUInteger)count pay:(NSString *)pay isMaster:(BOOL)isMaster
{
    [self setBackgroundColor:[UIColor whiteColor]];
    
    // 留言
    UILabel *noteTitleLabel = [[UILabel alloc] init];
    [noteTitleLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [noteTitleLabel setTextColor:HexColor(0x666666)];
    [noteTitleLabel setText:@"买家留言:"];
    [self addSubview:noteTitleLabel];
    [noteTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(28));
        make.top.equalTo(self).offset(fScreen(80 - 24)/2);
        make.height.mas_equalTo(fScreen(26));
        make.width.mas_equalTo(fScreen(140));
    }];
    
    HDLabel *noteLabel = [[HDLabel alloc] init];
    [noteLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
    [noteLabel setTextColor:HexColor(0x999999)];
    [noteLabel setText:note];
    [noteLabel setLineSpace:fScreen(8)];
    [noteLabel setWidth:kAppWidth - fScreen(28*2) - fScreen(140)];
    [noteLabel setAdjustsFontSizeToFitWidth:YES];
    [noteLabel setNumberOfLines:0];
    [self addSubview:noteLabel];
    [noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(noteTitleLabel.mas_right);
        make.right.equalTo(self).offset(-fScreen(28));
        make.top.equalTo(noteTitleLabel);
        make.height.mas_equalTo(noteLabel.textHeight - fScreen(10));
    }];
    
    UIView *noteLine = [[UIView alloc] init];
    [noteLine setBackgroundColor:viewControllerBgColor];
    [self addSubview:noteLine];
    [noteLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(fScreen(2));
        make.top.equalTo(noteLabel.mas_bottom).offset(fScreen(28));
    }];
    
    // 团长福利
    if (isMaster) {
        UILabel *masterTitleLabel = [[UILabel alloc] init];
        [masterTitleLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
        [masterTitleLabel setTextColor:HexColor(0x666666)];
        [masterTitleLabel setText:@"团长福利:"];
        [self addSubview:masterTitleLabel];
        [masterTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(noteLine.mas_bottom).offset(fScreen(28));
            make.left.right.height.equalTo(noteTitleLabel);
        }];
        
        UILabel *masterLabel = [[UILabel alloc] init];
        [masterLabel setFont:[UIFont systemFontOfSize:fScreen(26)]];
        [masterLabel setTextColor:HexColor(0x999999)];
        [masterLabel setText:@"拼团成功/失败全额退还"];
        [self addSubview:masterLabel];
        [masterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(noteLabel);
            make.height.mas_equalTo(fScreen(26));
            make.top.equalTo(masterTitleLabel);
        }];
        
        UIView *masterLine = [[UIView alloc] init];
        [masterLine setBackgroundColor:viewControllerBgColor];
        [self addSubview:masterLine];
        [masterLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.height.mas_equalTo(fScreen(2));
            make.top.equalTo(noteLine.mas_bottom).offset(fScreen(80));
        }];
    }
    
    // 共计
    UILabel *payMoneyLabel = [[UILabel alloc] init];
    [payMoneyLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [payMoneyLabel setTextColor:HexColor(0x666666)];
    [payMoneyLabel setTextAlignment:NSTextAlignmentRight];
    
    NSString *payString = [NSString stringWithFormat:@"共%ld件商品 共计:  ¥%@", count, pay];
    NSMutableAttributedString *payAttrString = [[NSMutableAttributedString alloc] initWithString:payString];
    [payAttrString addAttributes:@{NSForegroundColorAttributeName : HexColor(0xe44a62)} range:NSMakeRange(payString.length - (pay.length + 1) - 1, pay.length + 1)];
    [payMoneyLabel setAttributedText:payAttrString];
    [self addSubview:payMoneyLabel];
    [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-fScreen(28));
        make.left.equalTo(self).offset(fScreen(28));
        make.height.mas_equalTo(fScreen(24));
        if (isMaster) {
            make.top.equalTo(noteLine.mas_bottom).offset(fScreen(80 - 24)/2 + fScreen(80));
        }
        else {
            make.top.equalTo(noteLine.mas_bottom).offset(fScreen(80 - 24)/2);
        }
    }];
    
}

@end
