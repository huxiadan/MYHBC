//
//  BillsDetailController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/13.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "BillsDetailController.h"
#import "BillModel.h"
#import "BillCell.h"
#import <Masonry.h>

@interface BillsDetailController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, strong) UIView *typeSelectView;
@property (nonatomic, strong) UIView *optionView;

@property (nonatomic, strong) UITableView *billListView;    // 明细列表
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BillsDetailController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    [self hideTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self requestDataWithBillType:BillType_All];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestDataWithBillType:(BillType)billType
{
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:5];
    for (NSInteger index = 0; index < 5; index++) {
        BillModel *model = [[BillModel alloc] init];
        model.billDate = @"2016.12.12";
        if (index%3 == 0) {
            model.billType = BillType_BySelf;
            model.billAmount = @"1023.50";
        }
        else if (billType%3 == 1) {
            model.billType = BillType_ByTeam;
            model.billAmount = @"43.50";
        }
        else {
            model.billType = BillType_ByDelegate;
            model.billAmount = @"23.00";
        }
        [tmpArray addObject:model];
    }
    
    self.dataArray = [tmpArray copy];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"全部"];
    
    UIButton *changeButton = [[UIButton alloc] init];
    [changeButton setImage:[UIImage imageNamed:@"icon_pull"] forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"icon_pull_up"] forState:UIControlStateSelected];
    [changeButton addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:changeButton];
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(fScreen(88));
        make.bottom.equalTo(self.titleView.mas_bottom);
        make.width.mas_equalTo(fScreen(60) + viewControllerTitleFontSize*2);
        make.left.equalTo(self.titleView.mas_centerX);
    }];
    self.changeButton = changeButton;
    
    [self.view addSubview:self.billListView];
    [self.billListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(1);
    }];
    
    [self.view addSubview:self.typeSelectView];
    [self.typeSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.billListView);
        make.bottom.equalTo(self.view);
    }];
    [self.typeSelectView setAlpha:0];
    
}

#pragma mark - button click
- (void)changeButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        [self showOptionView];
    }
    else {
        [self hideOptionView];
    }
}

- (void)optionClick:(UIButton *)sender
{
    self.changeButton.selected = !self.changeButton.isSelected;
    
    [self.titleLabel setText:sender.titleLabel.text];
    
    if (sender.tag != BillType_All) {
        [self.changeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleView.mas_centerX).offset(viewControllerTitleFontSize);
        }];
    }
    else {
        [self.changeButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleView.mas_centerX);
        }];
    }
    
    [self hideOptionView];
}

#pragma mark - typeSelectView
- (void)showOptionView
{
    [UIView animateWithDuration:0.3f animations:^{
        [self.typeSelectView setAlpha:1];
        [self.typeSelectView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.15]];
    }];
}

- (void)hideOptionView
{
    self.changeButton.selected = NO;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.typeSelectView setAlpha:0];
        [self.typeSelectView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    }];
}

- (UIView *)typeSelectView
{
    if (!_typeSelectView) {
        UIView *view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        
        UIView *optionView = [[UIView alloc] init];
        [optionView setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:optionView];
        [optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(view);
            make.height.mas_equalTo(fScreen(88*4));
        }];
        self.optionView = optionView;
        
        NSArray *titleArray = @[@"全部", @"团队收款", @"代销收入", @"自营收入"];
        CGFloat topMargin = 0;
        for (NSInteger index = 0; index < 4; index++) {
            UIButton *button = [[UIButton alloc] init];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [button setTag:index];
            [button addTarget:self action:@selector(optionClick:) forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
            [button setTitle:[titleArray objectAtIndex:index] forState:UIControlStateNormal];
            [button setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
            [optionView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(optionView).offset(fScreen(30));
                make.height.mas_equalTo(fScreen(88));
                make.right.equalTo(optionView);
                make.top.equalTo(optionView).offset(topMargin);
            }];
            topMargin += fScreen(88);
            
            if (index != 3) {
                UIView *line = [[UIView alloc] init];
                [line setBackgroundColor:HexColor(0xdadada)];
                [optionView addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(button);
                    make.height.mas_equalTo(fScreen(2));
                    make.top.equalTo(button.mas_bottom);
                }];
            }
        }
        
        UIButton *hideButton = [[UIButton alloc] init];
        [hideButton addTarget:self action:@selector(hideOptionView) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:hideButton];
        [hideButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(view);
            make.top.equalTo(optionView.mas_bottom);
        }];
  
        _typeSelectView = view;
    }
    return _typeSelectView;
}


#pragma mark - tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[BillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    BillModel *model = (BillModel *)[self.dataArray objectAtIndex:indexPath.row];
    cell.billModel = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return fScreen(116);
}

#pragma mark - Getter
- (UITableView *)billListView
{
    if (!_billListView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView setDataSource:self];
        [tableView setDelegate:self];
        [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tableView setEstimatedRowHeight:fScreen(116)];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView setUserInteractionEnabled:NO];
        _billListView = tableView;
    }
    return _billListView;
}

@end
