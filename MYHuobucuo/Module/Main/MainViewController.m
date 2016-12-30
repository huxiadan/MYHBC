//
//  MainViewController.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "MainViewController.h"

#import "HDDeviceInfo.h"
#import "HDPageViewController.h"
#import "MYTabBarController.h"
#import "SearchViewController.h"
#import "MainModelController.h"
#import "YFGIFImageView.h"

#import <Masonry.h>

// test
#import "MainTestController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) HDPageViewController *pageController;

@property (nonatomic, strong) UIScrollView *guideView;

@end

@implementation MainViewController

#pragma mark - lift cycle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideNavigationBar];
    
    [self showTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method
- (void)initUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 启动图
    NSString *gifURLString = [[NSBundle mainBundle] pathForResource:@"default.gif" ofType:nil];
    YFGIFImageView *gifView = [[YFGIFImageView alloc] init];
    __weak typeof(gifView) weakGif = gifView;
    gifView.gifPath = gifURLString;
    gifView.unRepeat = YES;
    gifView.playingComplete = ^() {
        [weakGif removeFromSuperview];
    };
    [[[UIApplication sharedApplication] keyWindow] addSubview:gifView];
    gifView.frame = [[UIScreen mainScreen] bounds];
    [gifView startGIF];
    
    [self performSelector:@selector(delayUI) withObject:nil afterDelay:3.f];
}

- (void)delayUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    
    [self addTitleView];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    // 引导页
    DLog(@"%@", [HDUserDefaults objectForKey:cIsPlayGuideImage]);
    if ([[HDUserDefaults objectForKey:cIsPlayGuideImage] boolValue] == NO) {
    
        [self hideTabBar];
        self.guideView = [self makeGuideView];
        [self.view addSubview:self.guideView];
        
        [HDUserDefaults setObject:@YES forKey:cIsPlayGuideImage];
    }
}

// 引导页
- (UIScrollView *)makeGuideView
{
    UIScrollView *guideView = [[UIScrollView alloc] init];
    [guideView setPagingEnabled:YES];
    [guideView setBounces:NO];
    [guideView setShowsHorizontalScrollIndicator:NO];
    [guideView setFrame:CGRectMake(0, 0, kAppWidth, kAppHeight)];
    [guideView setContentSize:CGSizeMake(kAppWidth*4, 0)];
    
    for (NSInteger index = 0; index < 4; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"guide_%ld", index + 1]]];
        [guideView addSubview:imageView];
        [imageView setFrame:CGRectMake(kAppWidth * index, 0, kAppWidth, kAppHeight)];
        
        if (index == 3) {
            [imageView setUserInteractionEnabled:YES];
            
            UIButton *closeButton = [[UIButton alloc] init];
            [closeButton addTarget:self action:@selector(guideCloseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:closeButton];
            [closeButton setFrame:CGRectMake(0, kAppHeight*3/4, kAppWidth, kAppHeight/4)];
        }
    }
    
    return guideView;
}

- (void)addTitleView
{
    UIView *titleView = [[UIView alloc] init];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(88) + 20);
    }];
    self.titleView = titleView;
    
    UIImageView *iconView = [[UIImageView alloc] init];
    [iconView setImage:[UIImage imageNamed:@"icon_zhuye_logo-"]];
    [titleView addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView.mas_left).offset(fScreen(28));
        make.centerY.equalTo(titleView.mas_centerY).offset(10);
        make.width.mas_equalTo(fScreen(68));
        make.height.mas_equalTo(fScreen(68));
    }];
    
    UIButton *searchButton = [[UIButton alloc] init];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [searchButton setImage:[UIImage imageNamed:@"icon_search-nei"] forState:UIControlStateNormal];
    [searchButton setTitle:@"搜索更多优质好物" forState:UIControlStateNormal];
    [searchButton setTitleColor:HexColor(0xcecece) forState:UIControlStateNormal];
    [searchButton.layer setCornerRadius:fScreen(8)];
    [searchButton.layer setBorderColor:HexColor(0xdadada).CGColor];
    [searchButton.layer setBorderWidth:1.f];
    [searchButton.layer setMasksToBounds:YES];
    [searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:searchButton];
    [searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconView.mas_right).offset(fScreen(30));
        make.right.equalTo(titleView.mas_right).offset(-fScreen(30));
        make.height.mas_equalTo(fScreen(58));
        make.centerY.equalTo(iconView.mas_centerY);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [titleView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(titleView);
        make.height.equalTo(@1);
    }];
}

#pragma mark - button Click
- (void)searchButtonClick:(UIButton *)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc] initWithShopId:@""];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)guideCloseButtonClick:(UIButton *)sender
{
    [UIView animateWithDuration:0.5f animations:^{
        [self.guideView setAlpha:0];
    } completion:^(BOOL finished) {
        [self.guideView removeFromSuperview];
        [self showTabBar];
    }];
}

#pragma mark - Getter
- (HDPageViewController *)pageController
{
    if (!_pageController) {
        
        NSArray *titles = @[@"推荐", @"蔬菜", @"海鲜", @"青行灯", @"酒吞童子", @"茨木童子"];
        
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:6];
        for (NSInteger index = 0; index < 6; index++) {
            if (index == 0) {
                MainTestController *testVC = [[MainTestController alloc] init];
                testVC.currNavigationController = self.navigationController;
                [tmpArray addObject:testVC];
            }
            else {
                MainModelController *controller = [[MainModelController alloc] init];
                controller.currNavigationController = self.navigationController;
                [tmpArray addObject:controller];
            }
        }
        
        _pageController = [[HDPageViewController alloc] initWithFrame:CGRectZero titles:titles titleMargin:fScreen(78) titleHeight:0 firstTitleMargin:fScreen(48) titleFontSize:fScreen(28) controllers:[tmpArray copy]];
        
        _pageController.normalTitleColor = HexColor(0x999999);
        _pageController.TitleLineColor = HexColor(0xe44a62);
        _pageController.currTitleColor = HexColor(0xe44a62);
    }
    return _pageController;
}


@end
