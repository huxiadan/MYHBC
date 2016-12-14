//
//  GoodsGroupOhterGroupTabView.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/9.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsGroupOhterGroupTabView.h"
#import <Masonry.h>
#import <UIImageView+WebCache.h>
#import "GroupbuyOrderController.h"

static NSString *cellIdentity = @"GoodsGroupOhterGroupTabCellIdentity";

@interface GoodsGroupOhterGroupTabView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataList;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableDictionary *countDownTimeDict;       // 倒计时时间的数组

@end

@implementation GoodsGroupOhterGroupTabView

- (instancetype)initWithData:(NSArray *)dataList
{
    if (self = [super initWithFrame:CGRectZero style:UITableViewStyleGrouped]) {
        [self setDataSource:self];
        [self setDelegate:self];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setScrollEnabled:NO];
        
        self.dataList = dataList;
        
        self.countDownTimeDict = [NSMutableDictionary dictionary];
        for (NSInteger index = 0; index < dataList.count; index++)
        {
            OtherGroupModel *model = [dataList objectAtIndex:index];
            
            [self.countDownTimeDict setObjectSafe:model forKey:[NSIndexPath indexPathForRow:index inSection:0]];
        }
        
        [self starTimer];
    }
    return self;
}

- (void)endTimer
{
    [self.timer invalidate];
}

// 开启定时器,用于倒计时
- (void)starTimer
{
    if (!self.timer) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
        self.timer = timer;
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
}

- (void)refreshLessTime
{
    for (NSIndexPath *indexPath in self.countDownTimeDict.allKeys) {
        OtherGroupModel *model = [self.countDownTimeDict objectForKey:indexPath];
        model.endTime = --model.endTime;
        
        GoodsGroupOhterGroupTabCell *cell = [self cellForRowAtIndexPath:indexPath];
        cell.time = model.endTime;
    }
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsGroupOhterGroupTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        cell = [[GoodsGroupOhterGroupTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    OtherGroupModel *model = [self.dataList objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return fScreen(129 + 20);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OtherGroupModel *model = [self.dataList objectAtIndex:indexPath.row];
    
    GroupbuyOrderController *groupVC = [[GroupbuyOrderController alloc] initWithTitle:model.groupTitle groupId:model.groupId];
    [self.navController pushViewController:groupVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[GoodsGroupOhterGroupTabHeader alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return fScreen(52);
}

@end


#pragma mark - 
#pragma mark - tableView cell
@interface GoodsGroupOhterGroupTabCell ()

@property (nonatomic, strong) UIImageView *masterIcon;      // 团长头像
@property (nonatomic, strong) UILabel *nameLabel;           // 名称
@property (nonatomic, strong) UILabel *noEnoughLabel;       // 还差多少人
@property (nonatomic, strong) UILabel *endTimeLabel;        // 结束时间

@end

@implementation GoodsGroupOhterGroupTabCell

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
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"banner_pintuan"]];
    [self addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(fScreen(28));
        make.right.equalTo(self).offset(-fScreen(28));
        make.height.mas_equalTo(fScreen(129));
    }];
    
    // 头像
    UIImageView *masterIcon = [[UIImageView alloc] init];
    [masterIcon.layer setCornerRadius:fScreen(96/2)];
    [masterIcon.layer setMasksToBounds:YES];
    [bgImageView addSubview:masterIcon];
    [masterIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgImageView).offset(fScreen(12));
        make.centerY.equalTo(bgImageView);
        make.width.height.mas_equalTo(fScreen(96));
    }];
    self.masterIcon = masterIcon;
    
    // 名称
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [nameLabel setTextColor:HexColor(0x333333)];
    [bgImageView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(masterIcon.mas_right).offset(fScreen(28));
        make.top.equalTo(masterIcon).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.width.mas_equalTo(fScreen(184));
    }];
    self.nameLabel = nameLabel;
    
    // 还差多少人
    UILabel *noEnoughLabel = [[UILabel alloc] init];
    [noEnoughLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [noEnoughLabel setTextColor:HexColor(0x333333)];
    [noEnoughLabel setTextAlignment:NSTextAlignmentRight];
    [bgImageView addSubview:noEnoughLabel];
    [noEnoughLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(fScreen(10));
        make.top.equalTo(masterIcon).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.right.equalTo(bgImageView).offset(-fScreen(160 + 48));
    }];
    self.noEnoughLabel = noEnoughLabel;
    
    // 结束时间
    UILabel *endTimeLabel = [[UILabel alloc] init];
    [endTimeLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [endTimeLabel setTextColor:HexColor(0x333333)];
    [endTimeLabel setTextAlignment:NSTextAlignmentRight];
    [bgImageView addSubview:endTimeLabel];
    [endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(masterIcon.mas_right);
        make.top.equalTo(nameLabel.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(24));
        make.right.equalTo(noEnoughLabel);
    }];
    self.endTimeLabel = endTimeLabel;
}

- (void)setModel:(OtherGroupModel *)model
{
    _model = model;
    
    [self.masterIcon sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] placeholderImage:[UIImage imageNamed:@"placeholder.JPG"]];
    
    [self.nameLabel setText:model.groupUserName];
    
    [self.noEnoughLabel setText:[NSString stringWithFormat:@"还差%ld人成团", model.noEnoughNumber]];
    
    self.time = model.endTime;
}

- (void)setTime:(NSInteger)time
{
    _time = time;
    
    NSArray *timeArray = [self getTime:time];
    
    [self.endTimeLabel setText:[NSString stringWithFormat:@"本团将于%02ld:%02ld:%02ld后结束", [timeArray[0] integerValue], [timeArray[1] integerValue], [timeArray[2] integerValue]]];
}

- (NSArray *)getTime:(NSUInteger)seconds
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:3];
    
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    
    [tmpArray addObject:[NSNumber numberWithInteger:hour]];
    [tmpArray addObject:[NSNumber numberWithInteger:min]];
    [tmpArray addObject:[NSNumber numberWithInteger:second]];
    
    return [tmpArray copy];
}

@end

#pragma mark -
#pragma mark - tableview header
@implementation GoodsGroupOhterGroupTabHeader

- (instancetype)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:HexColor(0xe44a62)];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(fScreen(28));
            make.centerY.equalTo(self);
            make.width.mas_equalTo(fScreen(8));
            make.height.mas_equalTo(fScreen(30));
        }];
        
        UILabel *label = [[UILabel alloc] init];
        [label setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [label setTextColor:HexColor(0x666666)];
        [label setText:@"以下小伙伴正在发起拼团, 您可以直接参与"];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(fScreen(10));
            make.top.bottom.right.equalTo(self);
        }];
    }
    return self;
}

@end
