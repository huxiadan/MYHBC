//
//  MyWalletViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/10/21.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "MyWalletViewController.h"

#import <Masonry.h>
#import "MineWalletCell.h"
#import "SettingViewController.h"
#import "WalletWithdrawCashController.h"
#import "BillsDetailController.h"

#define kCellCount 6
#define cIconKey @"CellIconKey"
#define cTitleKey @"CellTitleKey"
#define cMoneyKey @"CellMoneyKey"

static NSString *cellIdentity = @"MineWalletCellIdentity";

@interface MyWalletViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *headerInfoView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIButton *withdrawButton; // 提现按钮

@property (nonatomic, strong) UILabel *totalIncomeMoneyLabel; // 累计收入
@property (nonatomic, strong) UILabel *leaveoverMoneyLabel;   // 余额

@property (nonatomic, strong) NSArray *cellDataArray;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self initData];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initData
{
    if (!self.cellDataArray) {
        NSArray *titleArray = @[@"待确认", @"提现中", @"已提现", @"自营收入", @"代销收入", @"团队收款"];
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:kCellCount];
        for (NSInteger index = 0; index < kCellCount; index++) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
            NSString *iconName = [NSString stringWithFormat:@"组-%ld",22 + index];
            
            [dict setObject:iconName forKey:cIconKey];
            [dict setObject:[NSString stringWithFormat:@"%@",[titleArray objectAtIndex:index]] forKey:cTitleKey];
            if (index%2 == 0) {
                [dict setObject:@"123.00" forKey:cMoneyKey];
            }
            else {
                [dict setObject:@"0.00" forKey:cMoneyKey];
            }
            
            [tmpArray addObject:dict];
        }
        
        self.cellDataArray = [tmpArray copy];
    }
}

- (void)initUI
{
    [self hideNavigationBar];
    [self hideTabBar];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    
    
    [self.headerInfoView setFrame:CGRectMake(0, 0, kAppWidth, fScreen(380))];
    [self.view addSubview:self.headerInfoView];
    
    [self.view addSubview:self.collectionView];

    UIButton *withDrawButton = [[UIButton alloc] init];
    [withDrawButton setBackgroundImage:[UIImage imageNamed:@"button-"] forState:UIControlStateNormal];
    [withDrawButton addTarget:self action:@selector(withdrawButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:withDrawButton];
    [withDrawButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.collectionView.mas_bottom).offset(fScreen(40));
        make.width.mas_equalTo(fScreen(680));
        make.height.mas_equalTo(fScreen(88));
    }];
    
    self.leaveoverMoneyLabel.text = @"10000.0";
    self.totalIncomeMoneyLabel.text = @"1024.0";
}

#pragma mark - Getter

- (UIView *)headerInfoView
{
    if (!_headerInfoView) {
        _headerInfoView = [[UIView alloc] init];
        
        // 背景
        UIImageView *bgImageView = [[UIImageView alloc] init];
        [bgImageView setImage:[UIImage imageNamed:@"组-28"]];
        [_headerInfoView addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(_headerInfoView);
        }];
        
        // 返回
        UIButton *backButton = [[UIButton alloc] init];
        [backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerInfoView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerInfoView.mas_top).offset(fScreen(50));
            make.left.equalTo(_headerInfoView.mas_left);
            make.width.mas_equalTo(fScreen(28 * 2 + 20));
            make.height.mas_equalTo(fScreen(40));
        }];

        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFont:[UIFont systemFontOfSize:viewControllerTitleFontSize]];
        [titleLabel setText:@"我的钱包"];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [_headerInfoView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_headerInfoView.mas_top).offset(fScreen(54));
            make.centerX.equalTo(_headerInfoView.mas_centerX);
            CGSize textSize = [titleLabel.text sizeForFontsize:viewControllerTitleFontSize];
            make.width.mas_equalTo(textSize.width + 4);
            make.height.mas_equalTo(textSize.height);
        }];

        UIButton *settingButton = [[UIButton alloc] init];
        [settingButton setImage:[UIImage imageNamed:@"icon-shezhi"] forState:UIControlStateNormal];
        [settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerInfoView addSubview:settingButton];
        [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerInfoView.mas_right);
            make.top.equalTo(_headerInfoView.mas_top).offset(fScreen(44));
            make.width.mas_equalTo(fScreen(44 + 28*2));
            make.height.mas_equalTo(fScreen(44 + 10*2));
        }];
        
        // 账单
        UIImageView *billImageView = [[UIImageView alloc] init];
        [billImageView setImage:[UIImage imageNamed:@"icon_more_w"]];
        [_headerInfoView addSubview:billImageView];
        [billImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerInfoView.mas_right).offset(-fScreen(28));
            make.width.mas_equalTo(fScreen(10));
            make.height.mas_equalTo(fScreen(20));
            make.centerY.equalTo(_headerInfoView.mas_centerY);
        }];
        
        UILabel *billLabel = [[UILabel alloc] init];
        [billLabel setText:@"账单"];
        [billLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [billLabel setTextColor:[UIColor whiteColor]];
        [_headerInfoView addSubview:billLabel];
        [billLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(billImageView.mas_left).offset(-fScreen(20));
            make.centerY.equalTo(billImageView.mas_centerY);
            CGSize textSize = [billLabel.text sizeForFontsize:fScreen(24)];
            make.width.mas_equalTo(textSize.width + 2);
            make.height.mas_equalTo(textSize.height);
        }];
        
        UIButton *billButton = [[UIButton alloc] init];
        [billButton addTarget:self action:@selector(billButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_headerInfoView addSubview:billButton];
        [billButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(billLabel.mas_left).offset(-fScreen(20));
            make.right.equalTo(_headerInfoView.mas_right);
            make.top.equalTo(billLabel.mas_top).offset(-fScreen(20));
            make.bottom.equalTo(billLabel.mas_bottom).offset(fScreen(20));
        }];

        // 累计收入
        UILabel *totalIncomeLabel = [[UILabel alloc] init];
        [totalIncomeLabel setText:@"累计收入 : ¥ "];
        [totalIncomeLabel setTextColor:[UIColor whiteColor]];
        [totalIncomeLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [_headerInfoView addSubview:totalIncomeLabel];
        [totalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerInfoView.mas_left).offset(fScreen(46));
            make.bottom.equalTo(_headerInfoView.mas_bottom).offset(-fScreen(88));
            CGSize textSize = [totalIncomeLabel.text sizeForFontsize:fScreen(24)];
            make.width.mas_equalTo(textSize.width + 2);
            make.height.mas_equalTo(textSize.height);
        }];

        self.totalIncomeMoneyLabel = [[UILabel alloc] init];
        [self.totalIncomeMoneyLabel setFont:[UIFont systemFontOfSize:fScreen(36)]];
        [self.totalIncomeMoneyLabel setTextColor:[UIColor whiteColor]];
        [_headerInfoView addSubview:self.totalIncomeMoneyLabel];
        [self.totalIncomeMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalIncomeLabel.mas_right);
            make.bottom.equalTo(totalIncomeLabel.mas_bottom);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(36)];
            make.right.equalTo(billButton.mas_left);
            make.height.mas_equalTo(textSize.height);
        }];

        // 余额
        UILabel *leaveoverLabel = [[UILabel alloc] init];
        [leaveoverLabel setText:@"余额 : ¥"];
        [leaveoverLabel setTextColor:[UIColor whiteColor]];
        [leaveoverLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [_headerInfoView addSubview:leaveoverLabel];
        [leaveoverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(totalIncomeLabel.mas_left);
            make.bottom.equalTo(totalIncomeLabel.mas_top).offset(-fScreen(58));
            CGSize textSize = [leaveoverLabel.text sizeForFontsize:fScreen(24)];
            make.width.mas_equalTo(textSize.width + 2);
            make.height.mas_equalTo(textSize.height);
        }];

        self.leaveoverMoneyLabel = [[UILabel alloc] init];
        [self.leaveoverMoneyLabel setFont:[UIFont systemFontOfSize:fScreen(50)]];
        [self.leaveoverMoneyLabel setTextColor:[UIColor whiteColor]];
        [_headerInfoView addSubview:self.leaveoverMoneyLabel];
        [self.leaveoverMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leaveoverLabel.mas_right);
            make.bottom.equalTo(leaveoverLabel.mas_bottom);
            CGSize textSize = [@"高度" sizeForFontsize:fScreen(50)];
            make.right.equalTo(billButton.mas_left);
            make.height.mas_equalTo(textSize.height - 4);
        }];
        
        // 保障
        UILabel *introductionsLabel = [[UILabel alloc] init];
        [introductionsLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.35]];
        [introductionsLabel.layer setCornerRadius:fScreen(20)];
        [introductionsLabel.layer setMasksToBounds:YES];
        [introductionsLabel setText:@"账户有保障 资金更安全"];
        [introductionsLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
        [introductionsLabel setTextColor:[UIColor whiteColor]];
        [introductionsLabel setTextAlignment:NSTextAlignmentCenter];
        [_headerInfoView addSubview:introductionsLabel];
        [introductionsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_headerInfoView.mas_right).offset(-fScreen(28));
            make.bottom.equalTo(_headerInfoView.mas_bottom).offset(-fScreen(30));
            make.height.mas_equalTo(fScreen(40));
            make.width.mas_equalTo(fScreen(340));
        }];
        
        UIImageView *baozhangLogo = [[UIImageView alloc] init];
        [baozhangLogo setImage:[UIImage imageNamed:@"保障-拷贝"]];
        [introductionsLabel addSubview:baozhangLogo];
        [baozhangLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(fScreen(22));
            make.height.mas_equalTo(fScreen(30));
            make.centerY.mas_equalTo(introductionsLabel.mas_centerY);
            make.left.equalTo(introductionsLabel.mas_left).offset(fScreen(16));
        }];
        
        // 箭头
        UIImageView *baozhangArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_more_w"]];
        [introductionsLabel addSubview:baozhangArrow];
        [baozhangArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(introductionsLabel.mas_right).offset(-fScreen(12));
            make.width.mas_equalTo(fScreen(10));
            make.height.mas_equalTo(fScreen(20));
            make.centerY.equalTo(introductionsLabel.mas_centerY);
        }];
        
    }
    return _headerInfoView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setMinimumLineSpacing:fScreen(20)];
        [layout setMinimumInteritemSpacing:fScreen(20)];
        
        [layout setItemSize:CGSizeMake(fScreen(218), fScreen(218))];
        
        CGRect frame = CGRectMake(fScreen(28), fScreen(380 + 30), kAppWidth - 2*fScreen(28), fScreen(218*2 + 20));
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
        [_collectionView registerClass:[MineWalletCell class] forCellWithReuseIdentifier:cellIdentity];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setBackgroundColor:self.view.backgroundColor];
    }
    return _collectionView;
}

#pragma mark - collectionView dataSource & delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kCellCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineWalletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentity forIndexPath:indexPath];
    
    NSDictionary *dict = (NSDictionary *)[self.cellDataArray objectAtIndex:indexPath.item];
    [cell setDataWithTitle:[dict objectForKey:cTitleKey]
                     money:[dict objectForKey:cMoneyKey]
                 imageName:[dict objectForKey:cIconKey]];
    
    return cell;
}

#pragma mark - Button click
- (void)backButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 设置按钮点击
- (void)settingButtonClick:(UIButton *)sender
{
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

// 账单按钮点击
- (void)billButtonClick:(UIButton *)sender
{
    BillsDetailController *billVC = [[BillsDetailController alloc] init];
    [self.navigationController pushViewController:billVC animated:YES];
}

// 我要提现点击
- (void)withdrawButtonClick:(UIButton *)sender
{
    WalletWithdrawCashController *withDrawCashVC = [[WalletWithdrawCashController alloc] init];
    [self.navigationController pushViewController:withDrawCashVC animated:YES];
}

@end
