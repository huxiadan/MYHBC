//
//  GoodsSpecParamsController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/17.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GoodsSpecParamsController.h"
#import <Masonry.h>

static NSString *cellIdentity = @"GoodsSpecParamsTabCellIdentity";

@interface GoodsSpecParamsController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *paramsView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation GoodsSpecParamsController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self.view addSubview:self.paramsView];
    [self.paramsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(fScreen(10));
        make.height.mas_equalTo(kAppHeight - 20 - fScreen(88) - fScreen(100) - fScreen(112) - fScreen(10) - fScreen(10));
    }];
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsSpecParamsTabCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        cell = [[GoodsSpecParamsTabCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    GoodsSpecParamsModel *model = (GoodsSpecParamsModel *)[self.dataArray objectAtIndex:indexPath.row];
    cell.model = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsSpecParamsModel *model = (GoodsSpecParamsModel *)[self.dataArray objectAtIndex:indexPath.row];
    return model.rowHeight;
}


- (UITableView *)paramsView
{
    if (!_paramsView) {
        _paramsView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_paramsView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_paramsView setDataSource:self];
        [_paramsView setDelegate:self];
    }
    return _paramsView;
}

- (void)setTextArray:(NSArray *)textArray
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:textArray.count];
    for (NSArray *array in textArray) {
        GoodsSpecParamsModel *model = [[GoodsSpecParamsModel alloc] init];
        model.name = array[0];
        model.info = array[1];
        [tmpArray addObject:model];
    }
    self.dataArray = [tmpArray copy];
}

@end


#pragma mark - GoodsSpecParamsTabCell

@interface GoodsSpecParamsTabCell ()

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation GoodsSpecParamsTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setNumberOfLines:0];
    [nameLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [nameLabel setTextColor:HexColor(0x666666)];
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(fScreen(28));
        make.top.equalTo(self.mas_top).offset(fScreen(30));
        CGSize textSize = [@"商品名称" sizeForFontsize:fScreen(24)];
        make.height.mas_equalTo(textSize.height);
        make.width.mas_equalTo(textSize.width + 2);
    }];
    self.nameLabel = nameLabel;
    
    UILabel *infoLabel = [[UILabel alloc] init];
    [infoLabel setNumberOfLines:0];
    [infoLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [infoLabel setTextColor:HexColor(0x999999)];
    [self addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_right).offset(fScreen(50));
        make.right.equalTo(self.mas_right).offset(-fScreen(28));
        make.top.equalTo(nameLabel.mas_top);
        make.height.mas_equalTo(fScreen(24));
    }];
    self.infoLabel = infoLabel;
}

- (void)setModel:(GoodsSpecParamsModel *)model
{
    _model = model;
    
    NSString *nameString = model.name;
    [self.nameLabel setText:nameString];
    CGFloat nameWidth = [@"商品名称" sizeForFontsize:fScreen(24)].width + 2;
    CGSize nameContainSize = CGSizeMake(nameWidth, MAXFLOAT);
    CGSize nameSize = [nameString boundingRectWithSize:nameContainSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.nameLabel.font} context:nil].size;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(nameSize.height > fScreen(54) ? fScreen(54) : nameSize.height);
    }];
    
    NSString *infoString = model.info;
    [self.infoLabel setText:infoString];
    CGFloat infoWidth = kAppWidth - nameSize.width - fScreen(28 + 28);
    CGSize infoContainSize = CGSizeMake(infoWidth, MAXFLOAT);
    CGSize infoSize = [infoString boundingRectWithSize:infoContainSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.infoLabel.font} context:nil].size;
    [self.infoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(infoSize.height + fScreen(5));
    }];
}

@end


#pragma mark - GoodsSpecParamsModel
@implementation GoodsSpecParamsModel

- (void)setName:(NSString *)name
{
    _name = name;
    
    CGFloat nameWidth = [@"商品名称" sizeForFontsize:fScreen(24)].width + 2;
    CGSize nameContainSize = CGSizeMake(nameWidth, MAXFLOAT);
    CGSize nameSize = [name boundingRectWithSize:nameContainSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]} context:nil].size;
    if (self.rowHeight < nameSize.height + fScreen(30)) {
        self.rowHeight = nameSize.height + fScreen(30);
    }
}

- (void)setInfo:(NSString *)info
{
    _info = info;
    
    CGFloat infoWidth = kAppWidth - [@"商品名称" sizeForFontsize:fScreen(24)].width - fScreen(28 + 28);
    CGSize infoContainSize = CGSizeMake(infoWidth, MAXFLOAT);
    CGSize infoSize = [info boundingRectWithSize:infoContainSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:fScreen(24)]} context:nil].size;
    if (self.rowHeight < infoSize.height + fScreen(30)) {
        self.rowHeight = infoSize.height + fScreen(30);
    }
}



@end
