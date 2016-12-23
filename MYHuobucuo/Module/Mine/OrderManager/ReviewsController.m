//
//  ReviewsController.m
//  MYHuobucuo
//
//  Created by hudan on 16/12/14.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "ReviewsController.h"
#import <Masonry.h>
#import "ReviewsCell.h"
#import "reviewModel.h"


@interface ReviewsController () <UITableViewDataSource, UITableViewDelegate>

// UI
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UITableView *listView;


// data
@property (nonatomic, strong) OrderShopModel *model;
@property (nonatomic, strong) NSArray *reviewModelArray;    // 数据源

@end

@implementation ReviewsController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    [self hideTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithOrderModel:(OrderShopModel *)orderShopModel
{
    if (self = [super init]) {
        self.model = orderShopModel;
        
        if (self.model.goodsArray.count > 0) {
            NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:self.model.goodsArray.count];
            
            for (OrderModel *orderModel in self.model.goodsArray) {
                reviewModel *model = [[reviewModel alloc] init];
                model.orderModel = orderModel;
                [tmpArray addObject:model];
            }
            
            self.reviewModelArray = tmpArray;
        }
    }
    return self;
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    self.titleView = [self addTitleViewWithTitle:@"发表评价"];
    
    [self addListView];
    
    [self addBottomView];
}

- (void)addBottomView
{
    // 底部提交评价
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(fScreen(102));
    }];
    
    UIButton *anonymityButton = [[UIButton alloc] init];
    [anonymityButton setImage:[UIImage imageNamed:@"icon_no"] forState:UIControlStateNormal];
    [anonymityButton setImage:[UIImage imageNamed:@"icon_ok"] forState:UIControlStateSelected];
    [anonymityButton addTarget:self action:@selector(anonymityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:anonymityButton];
    [anonymityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bottomView);
        make.width.mas_equalTo(fScreen(28*2 + 35));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [titleLabel setTextColor:HexColor(0x333333)];
    [titleLabel setText:@"匿名评价"];
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView).offset(fScreen(28 + 35 + 12));
        make.top.bottom.equalTo(bottomView);
        make.width.mas_equalTo(fScreen(130));
    }];
    
    UIButton *sendButton = [[UIButton alloc] init];
    [sendButton setTitle:@"发表评价" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [sendButton setBackgroundColor:HexColor(0xe44a62)];
    [sendButton addTarget:self action:@selector(sendReviewClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:sendButton];
    [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(bottomView);
        make.width.mas_equalTo(fScreen(188));
    }];
}

- (void)addListView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [tableView setBackgroundColor:viewControllerBgColor];
    [tableView setEstimatedRowHeight:fScreen(590)];
    [tableView setDataSource:self];
    [tableView setDelegate:self];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(10));
        make.bottom.equalTo(self.view).offset(-fScreen(102) -1);
    }];
    self.listView = tableView;
}

#pragma mark - button click
// 发表评价
- (void)sendReviewClick:(UIButton *)sender
{
    
}

// 匿名发表
- (void)anonymityButtonClick:(UIButton *)sender
{
    sender.selected = !sender.isSelected;
}

#pragma mark - tableView dataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.reviewModelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    
    if (!cell) {
        cell = [[ReviewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    
    cell.model = (reviewModel *)[self.reviewModelArray objectAtIndex:indexPath.row];
    cell.navController = self.navigationController;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return fScreen(610);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
