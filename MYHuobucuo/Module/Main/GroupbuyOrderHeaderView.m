//
//  GroupbuyOrderHeaderView.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/23.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupbuyOrderHeaderView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "GroupbuyOrderTabCell.h"

@interface GroupbuyOrderHeaderView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GroupbuyOrderModel *model;

@property (nonatomic, strong) UIView *goodsInfoView;                // 团购信息
@property (nonatomic, strong) UIView *groupMenberView;              // 团购人员
@property (nonatomic, strong) UIImageView *groupMenberListView;     // 已参团成员列表
@property (nonatomic, strong) UILabel *bottomView;                  // 底部按钮
@property (nonatomic, strong) UIView *commissionView;               // 佣金

@property (nonatomic, strong) UIImageView *goodsImage;

@property (nonatomic, strong) UILabel *dayLabel;        // 天
@property (nonatomic, strong) UILabel *hourLabel;       // 小时
@property (nonatomic, strong) UILabel *minLabel;        // 分钟
@property (nonatomic, strong) UILabel *secLabel;        // 秒

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat memberListHeight;

@end

@implementation GroupbuyOrderHeaderView

- (instancetype)initWithModel:(GroupbuyOrderModel *)model
{
    if (self = [super init]) {
        self.model = model;
        
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self setBackgroundColor:viewControllerBgColor];
    
    // 团购信息
    [self addSubview:self.goodsInfoView];
    [self.goodsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(192));
        make.right.equalTo(self).offset(-fScreen(20));
    }];
    
    self.height = fScreen(20 + 192);
    
    // 佣金
    if (self.model.commissionString.length > 0) {
        [self addSubview:self.commissionView];
        [self.commissionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.goodsInfoView);
            make.top.equalTo(self.goodsInfoView.mas_bottom);
            make.height.mas_equalTo(fScreen(58));
        }];
        
        self.height += fScreen(58);
    }
    
    // 组团信息
    [self addSubview:self.groupMenberView];
    // 满6个的行数
    NSInteger membeiRowNum = [[NSNumber numberWithFloat:self.model. groupCount/6] integerValue];
    // 不满6个的行数
    if (self.model.groupCount % 6 > 0) {
        membeiRowNum += 1;
    }
        
    CGFloat memberHeight = fScreen(90 + 20) * membeiRowNum;
    if (self.model.commissionString.length > 0) {
        if (self.model.groupTime == 0) {
            memberHeight += fScreen(28);
            memberHeight += fScreen(22 + 32 + 20 + 24);
        }
        else {
            memberHeight += fScreen(28 + 28);
            memberHeight += fScreen(48);
        }
    }
    else {
        if (self.model.groupTime == 0) {
            memberHeight += fScreen(22);
            memberHeight += fScreen(22 + 32 + 20 + 24);
        }
        else {
            memberHeight += fScreen(34 + 20);
            memberHeight += fScreen(48);
        }
    }
 
    [self.groupMenberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(fScreen(90 + 20)*5 + fScreen(90));
        if (self.model.commissionString.length > 0) {
            make.top.equalTo(self.commissionView.mas_bottom).offset(fScreen(28));
        }
        else {
            make.top.equalTo(self.goodsInfoView.mas_bottom).offset(fScreen(20));
        }
        make.height.mas_equalTo(memberHeight);
    }];
    
    self.height += memberHeight;
    
    if (self.model.groupTime == 0) {
        // 添加展开收起
        self.height += fScreen(24);
    }

    // 组团成员列表
    [self addSubview:self.groupMenberListView];
    CGFloat listViewHeight = self.model.memberList.count * fScreen(90 + 20) + fScreen(40);
    self.memberListHeight = listViewHeight;
    [self.groupMenberListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(20));
        make.right.equalTo(self).offset(-fScreen(20));
        make.top.equalTo(self.groupMenberView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(listViewHeight);
    }];

    self.height += listViewHeight;
    
    // 底部
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(fScreen(28));
        make.top.equalTo(self.groupMenberListView.mas_bottom).offset(fScreen(40));
        make.height.mas_equalTo(fScreen(28));
        make.right.equalTo(self);
    }];
    
    self.height += fScreen(40 + 28 + 20) + fScreen(20)*2;
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.memberList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupbuyOrderTabCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupbuyOrderTabCellIdentity];
    if (!cell) {
        cell = [[GroupbuyOrderTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GroupbuyOrderTabCellIdentity];
    }
    
    GroupMemberModel *model = [self.model.memberList objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return fScreen(90 + 20);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return fScreen(90 + 20);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GroupbuyOrderTabHeader *header = [[GroupbuyOrderTabHeader alloc] init];
    GroupMemberModel *model = (GroupMemberModel *)[self.model.memberList objectAtIndex:0];
    header.model = model;
    return header;
}

#pragma mark - button click
- (void)pickButtonClick:(UIButton *)sender
{
    CGFloat listViewHeight;
    if (sender.tag == 0) {
        sender.tag = 1;
        listViewHeight = 0;
    }
    else {
        sender.tag = 0;
        listViewHeight = self.memberListHeight;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        [self.groupMenberListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(listViewHeight);
        }];
        [self.bottomView layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (self.pickUpBlock) {
            self.pickUpBlock(sender.tag, self.memberListHeight);
        }
    }];
}

#pragma mark - Getter

- (UIView *)commissionView
{
    if (!_commissionView) {
        UIView *commissionView = [[UIView alloc] init];
        [commissionView setBackgroundColor:HexColor(0xff8c53)];
        _commissionView = commissionView;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_coupons"]];
        [commissionView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(commissionView).offset(fScreen(60));
            make.centerY.equalTo(commissionView);
            make.width.mas_equalTo(fScreen(26));
            make.height.mas_equalTo(fScreen(22));
        }];
        
        UILabel *titleLabel = [self makeColonLabel];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setText:@"佣金团"];
        [commissionView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(fScreen(10));
            make.height.mas_equalTo(fScreen(24));
            make.width.mas_equalTo(fScreen(74));
            make.centerY.equalTo(icon);
        }];
        
        UILabel *infoLabel = [[UILabel alloc] init];
        [infoLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [infoLabel setTextColor:[UIColor whiteColor]];
        [commissionView addSubview:infoLabel];
        [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel.mas_right).offset(fScreen(48));
            make.right.top.bottom.equalTo(commissionView);
        }];
        
        NSString *infoString = [NSString stringWithFormat:@"邀请好友参加可赚取最多¥%@的佣金", self.model.commissionString];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:infoString];
        NSDictionary *attrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]};
        NSRange commissionRange = [infoString rangeOfString:self.model.commissionString];
        [attrString addAttributes:attrDict range:NSMakeRange(0, commissionRange.location)];
        [attrString addAttributes:attrDict range:NSMakeRange(commissionRange.location + commissionRange.length - 2, infoString.length - commissionRange.location - commissionRange.length)];
        [infoLabel setAttributedText:attrString];
    }
    return _commissionView;
}

- (UIView *)groupMenberView
{
    if (!_groupMenberView) {
        _groupMenberView = [[UIView alloc] init];
        
        NSUInteger rowNumber = [[NSNumber numberWithFloat:self.model.groupCount/6] integerValue];
        NSUInteger lastRowIconNum = [[NSNumber numberWithFloat:self.model.groupCount % 6] integerValue];
        
        // 最开始距离顶部的距离
        CGFloat initTopMargin = self.model.groupTime == 0 ? fScreen(22) : fScreen(34 + 20);
        // 缓存最后一个 cell,用户布局
        UIView *lastCell;
        
        // 满6个的一行
        if (rowNumber > 0) {
            for (NSInteger index = 0; index < rowNumber; index++) {
                UIView *cellView = [self makeMemberViewCell:index isFull:YES];
                [_groupMenberView addSubview:cellView];
                [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(_groupMenberView);
                    make.top.equalTo(_groupMenberView).offset(index * fScreen(90 + 20) + initTopMargin);
                    make.height.mas_equalTo(fScreen(90));
                }];
                
                if (index == rowNumber - 1) {
                    if (lastRowIconNum == 0) {
                        lastCell = cellView;
                    }
                }
            }
        }
        // 不满6个的一行,最后一行
        if (lastRowIconNum > 0) {
            UIView *cellView = [self makeMemberViewCell:rowNumber isFull:NO];
            [_groupMenberView addSubview:cellView];
            [cellView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_groupMenberView.mas_centerX);
                make.height.mas_equalTo(fScreen(90));
                make.width.mas_equalTo(fScreen(90 + 20)*(lastRowIconNum - 1) + fScreen(90));
                make.top.equalTo(_groupMenberView).offset(rowNumber * fScreen(90 + 20) + initTopMargin);
            }];
            lastCell = cellView;
        }
        
        // 底部文字
        if (self.model.groupTime == 0) {
            UILabel *groupStateLabel = [[UILabel alloc] init];
            [groupStateLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
            [groupStateLabel setTextColor:HexColor(0x333333)];
            [groupStateLabel setTextAlignment:NSTextAlignmentCenter];
            [_groupMenberView addSubview:groupStateLabel];
            [groupStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_groupMenberView);
                make.height.mas_equalTo(fScreen(32));
                make.top.equalTo(lastCell.mas_bottom).offset(fScreen(42));
            }];
            if (self.model.isGroupSuccess) {
                // 组团成功
                if (self.model.isMyGroup) {
                    [groupStateLabel setText:@"组团成功! 请等待商家发货."];
                }
                else {
                    [groupStateLabel setText:@"他已组团成功! 您可以自己发起拼团."];
                }
            }
            else {
                // 组团失败
                if (self.model.isMyGroup) {
                    [groupStateLabel setText:@"组团失败! 再新开一个团吧."];
                }
                else {
                    [groupStateLabel setText:@"该团拼团失败! 您可以自己发起拼团."];
                }
            }
            
            // 展开收起按钮
            UIView *pickUpView = [self makePickUpView];
            [_groupMenberView addSubview:pickUpView];
            [pickUpView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(_groupMenberView);
                make.height.mas_equalTo(fScreen(10 + 24 + 10));
                make.width.mas_equalTo(fScreen(20 + 148 + 10 + 10 + 20));
                make.top.equalTo(groupStateLabel.mas_bottom).offset(fScreen(10));
            }];
        }
        else {
            // 顶部团购时间倒计时
            UIView *timeDownView = [self makeTimeDownView];
            [_groupMenberView addSubview:timeDownView];
            [timeDownView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_groupMenberView);
                make.top.equalTo(_groupMenberView);
                make.height.mas_equalTo(fScreen(34));
            }];
            
            __weak typeof(self) weakSelf = self;
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
                [weakSelf timeChangeWithTimer:timer];
            }];
            
            self.timer = timer;
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
            
            // 底部还差多少人
            UILabel *label = [[UILabel alloc] init];
            [label setFont:[UIFont systemFontOfSize:fScreen(48)]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label setTextColor:HexColor(0xe44a62)];
            NSInteger number = self.model.groupCount - self.model.memberList.count;
            NSString *numberStr = [NSString stringWithFormat:@"%ld", number];
            NSString *string = [NSString stringWithFormat:@"还差%@人,  邀请好友就能成功开团", numberStr];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
            NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(28)], NSForegroundColorAttributeName : HexColor(0x333333)};
            [attrString addAttributes:attr range:NSMakeRange(0, 2)];
            [attrString addAttributes:attr range:NSMakeRange(2 + numberStr.length, string.length - 2 - numberStr.length)];
            
            [label setAttributedText:attrString];
            [_groupMenberView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(_groupMenberView);
                make.height.mas_equalTo(fScreen(48));
                make.top.equalTo(lastCell.mas_bottom).offset(fScreen(20));
            }];
        }
    }
    return _groupMenberView;
}

- (UIView *)makePickUpView
{
    UIView *pickUpView = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] init];
    [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [label setTextColor:HexColor(0x333333)];
    [label setText:@"收起拼团详情"];
    [pickUpView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pickUpView).offset(fScreen(20));
        make.width.mas_equalTo(fScreen(148));
        make.height.mas_equalTo(fScreen(24));
        make.top.equalTo(pickUpView).offset(fScreen(10));
    }];
    
    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group_icon_more"]];
    [pickUpView addSubview:arrowView];
    [arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(fScreen(10));
        make.width.mas_equalTo(fScreen(10));
        make.height.mas_equalTo(fScreen(8));
        make.centerY.equalTo(label);
    }];
    
    UIButton *pickButton = [[UIButton alloc] init];
    [pickButton addTarget:self action:@selector(pickButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [pickUpView addSubview:pickButton];
    [pickButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(pickUpView);
    }];
    
    return pickUpView;
}

- (void)timeChangeWithTimer:(NSTimer *)timer
{
    self.model.groupTime -= 1;
    NSUInteger time = self.model.groupTime;
    if (time == 0) {
        [timer invalidate];
    }
    
    NSUInteger day = (NSUInteger)time/(24 * 3600);
    NSUInteger hour = (NSUInteger)(time%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(time%(3600))/60;
    NSUInteger second = (NSUInteger)(time%60);
    
    self.dayLabel.text = [NSString stringWithFormat:@"%ld", day];
    self.hourLabel.text = [NSString stringWithFormat:@"%02ld", hour];
    self.minLabel.text = [NSString stringWithFormat:@"%02ld", min];
    self.secLabel.text = [NSString stringWithFormat:@"%02ld", second];
}

- (UIView *)makeTimeDownView
{
    BOOL isCommission = self.model.commissionString.length == 0 ? NO : YES;
    
    UIView *view = [[UIView alloc] init];
    
    UILabel *colonCenter = [self makeColonLabel];
    [view addSubview:colonCenter];
    [colonCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(10));
    }];
    
    UILabel *hourLabel = [self makeTimeLabel];
    [view addSubview:hourLabel];
    [hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(colonCenter.mas_left);
        make.height.mas_equalTo(fScreen(34));
        make.width.mas_equalTo(isCommission ? fScreen(36) : fScreen(42));
    }];
    self.hourLabel = hourLabel;
    
    UILabel *colonLeft = [self makeColonLabel];
    [view addSubview:colonLeft];
    [colonLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(colonCenter);
        make.right.equalTo(hourLabel.mas_left);
    }];
    
    UILabel *dayLabel = [self makeTimeLabel];
    [view addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(hourLabel);
        make.right.equalTo(colonLeft.mas_left);
        make.width.mas_equalTo(isCommission ? fScreen(24) : fScreen(28));
    }];
    self.dayLabel = dayLabel;
    
    UILabel *leftLabel = [self makeColonLabel];
    [leftLabel setText:@"本团将于"];
    [leftLabel setTextColor:HexColor(0x999999)];
    [leftLabel setTextAlignment:NSTextAlignmentRight];
    [view addSubview:leftLabel];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(colonLeft);
        make.left.equalTo(view);
        make.right.equalTo(dayLabel.mas_left);
    }];
    
    UILabel *minLabel = [self makeTimeLabel];
    [view addSubview:minLabel];
    [minLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(hourLabel);
        make.left.equalTo(colonCenter.mas_right);
    }];
    self.minLabel = minLabel;
    
    UILabel *colonRight = [self makeColonLabel];
    [view addSubview:colonRight];
    [colonRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(colonCenter);
        make.left.equalTo(minLabel.mas_right);
    }];
    
    UILabel *secLabel = [self makeTimeLabel];
    [view addSubview:secLabel];
    [secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.width.equalTo(minLabel);
        make.left.equalTo(colonRight.mas_right);
    }];
    self.secLabel = secLabel;
    
    UILabel *rightLabel = [self makeColonLabel];
    [rightLabel setTextColor:HexColor(0x999999)];
    [rightLabel setTextAlignment:NSTextAlignmentLeft];
    [rightLabel setText:@"后结束"];
    [view addSubview:rightLabel];
    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.height.equalTo(leftLabel);
        make.left.equalTo(secLabel.mas_right);
        make.right.equalTo(view);
    }];
    
    [self timeChangeWithTimer:nil];
    
    return view;
}

- (UILabel *)makeColonLabel
{
    UILabel *label = [[UILabel alloc] init];
    
    [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [label setText:@":"];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:HexColor(0x333333)];
    
    return label;
}

- (UILabel *)makeTimeLabel
{
    UILabel *label = [[UILabel alloc] init];
    
    [label setTextAlignment:NSTextAlignmentCenter];
    
    if (self.model.commissionString.length == 0) {
        [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:HexColor(0x333333)];
        [label.layer setCornerRadius:fScreen(6)];
        [label.layer setMasksToBounds:YES];
    }
    else {
        [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [label setTextColor:HexColor(0x333333)];
    }

    return label;
}

/**
 创建每行的视图

 @param rowIndex 行号
 @param isFull 是否是满的6个一行
 @return 创建好的视图
 */
- (UIView *)makeMemberViewCell:(NSInteger)rowIndex isFull:(BOOL)isFull
{
    UIView *cellView = [[UIView alloc] init];
    
    CGFloat iconWidth = fScreen(90);
    CGFloat iconMargin = fScreen(20);
    CGFloat x = 0;
    NSInteger count = 0;
    if (isFull) {
        count = 6;
    }
    else {
        count = [[NSNumber numberWithFloat:self.model.groupCount % 6] integerValue];
    }
    
    for (NSInteger index = 0; index < count; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
        [imageView.layer setBorderWidth:fScreen(3)];
        [imageView.layer setCornerRadius:iconWidth/2];
        
        // 是否有用户
        NSInteger currIndex = rowIndex * 6 + index;
        if (currIndex > self.model.memberList.count - 1) {
            // 没有用户,显示"缺"
            [imageView setImage:[UIImage imageNamed:@"img_kong"]];
        }
        else {
            GroupMemberModel *member = (GroupMemberModel *)[self.model.memberList objectAtIndex:currIndex];
            if (member.userIconUrl.length > 0) {
                [imageView sd_setImageWithURL:[NSURL URLWithString:member.userIconUrl] placeholderImage:[UIImage imageNamed:@"img_boy"]];
            }
            else {
                [imageView setImage:[UIImage imageNamed:@"img_boy"]];
            }
        }
        
        CGRect imageFrame = CGRectMake(x + (iconMargin + iconWidth) * index, 0, iconWidth, iconWidth);
        [imageView setFrame:imageFrame];
        [cellView addSubview:imageView];
        
        if (currIndex == 0) {
            // 团长
            UIImageView *masterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tal_tuanzhang"]];
            
            CGRect masterFrame = CGRectMake(iconWidth - fScreen(36), 0, fScreen(48), fScreen(22));
            [masterView setFrame:masterFrame];
            [cellView addSubview:masterView];
        }
    }
    
    return cellView;
}

- (UIImageView *)groupMenberListView
{
    if (!_groupMenberListView) {
        
        UIImage *bgImage = [UIImage imageNamed:@"juxing@2x"];
        bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(fScreen(42), 1, 1, 1) resizingMode:UIImageResizingModeStretch];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [tableView setEstimatedRowHeight:fScreen(90 + 20)];
        
        [bgImageView addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(bgImageView);
            make.top.equalTo(bgImageView).offset(fScreen(42));
        }];
        
        _groupMenberListView = bgImageView;
    }
    return _groupMenberListView;
}

- (UILabel *)bottomView
{
    if (!_bottomView) {
        UILabel *label = [[UILabel alloc] init];
        [label setTextColor:HexColor(0x333333)];
        [label setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [label setText:@"你可能会喜欢"];
        _bottomView = label;
    }
    return _bottomView;
}

- (UIView *)goodsInfoView
{
    if (!_goodsInfoView) {
        UIView *infoView = [[UIView alloc] init];
        [infoView setBackgroundColor:[UIColor whiteColor]];
        _goodsInfoView = infoView;
        
        UIImageView *goodsImageView = [[UIImageView alloc] init];
        [goodsImageView sd_setImageWithURL:[NSURL URLWithString:self.model.goodsImageUrl] placeholderImage:[UIImage imageNamed:@"img_load_square"]];
        [infoView addSubview:goodsImageView];
        [goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(infoView).offset(fScreen(20));
            make.bottom.equalTo(infoView).offset(-fScreen(20));
            make.width.mas_equalTo(fScreen(150));
        }];
        
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [nameLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [nameLabel setTextColor:HexColor(0x333333)];
        [nameLabel setNumberOfLines:2];
        [nameLabel setText:self.model.goodsName];
        CGSize textSize = [nameLabel.text boundingRectWithSize:CGSizeMake(kAppWidth - fScreen(2*20) - fScreen(2*20) - fScreen(150 + 20), 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : nameLabel.font} context:nil].size;
        CGFloat textHeight = textSize.height > fScreen(28*2 + 12) ? fScreen(28*2 + 12) : textSize.height;
        [infoView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(goodsImageView.mas_right).offset(fScreen(20));
            make.top.equalTo(goodsImageView);
            make.right.equalTo(infoView).offset(-fScreen(20));
            make.height.mas_equalTo(textHeight);
        }];
        
        UILabel *wuliuLabel = [[UILabel alloc] init];
        [wuliuLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
        [wuliuLabel setTextColor:HexColor(0x333333)];
        [wuliuLabel setText:self.model.wuliuInfo];
        [infoView addSubview:wuliuLabel];
        [wuliuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(nameLabel);
            make.height.mas_equalTo(fScreen(28));
            make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(10));
        }];
        
        UILabel *groupCountLabel = [[UILabel alloc] init];
        [groupCountLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [groupCountLabel setTextColor:HexColor(0x333333)];
        [groupCountLabel setText:[NSString stringWithFormat:@"%ld人团:", self.model.groupCount]];
        [infoView addSubview:groupCountLabel];
        [groupCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel);
            make.bottom.equalTo(goodsImageView);
            make.height.mas_equalTo(fScreen(24));
            CGSize textSize = [groupCountLabel.text sizeForFontsize:fScreen(24)];
            make.width.mas_equalTo(textSize.width + 1);
        }];
        
        UILabel *priceLabel = [[UILabel alloc] init];
        [priceLabel setFont:[UIFont systemFontOfSize:fScreen(32)]];
        [priceLabel setTextColor:HexColor(0xe44a62)];
        
        NSMutableAttributedString *priceAttrString = [[NSMutableAttributedString alloc] initWithString:self.model.groupPrice];
        NSRange bigRange = [self.model.groupPrice rangeOfString:self.model.groupPriceBig];
        NSDictionary *attrDict = @{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]};
        [priceAttrString addAttributes:attrDict range:NSMakeRange(0, bigRange.location)];
        [priceAttrString addAttributes:attrDict range:NSMakeRange(bigRange.location + bigRange.length, priceAttrString.length - (bigRange.location + bigRange.length))];
        priceLabel.attributedText = priceAttrString;
        [infoView addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(groupCountLabel.mas_right).offset(fScreen(10));
            make.height.mas_equalTo(fScreen(32));
            make.baseline.equalTo(groupCountLabel);
            make.right.equalTo(infoView).offset(-fScreen(20));
        }];
    }
    return _goodsInfoView;
}

@end
