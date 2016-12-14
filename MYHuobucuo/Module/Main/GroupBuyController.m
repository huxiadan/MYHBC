//
//  GroupBuyController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/22.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "GroupBuyController.h"

#import "HDPageViewController.h"
#import "GroupBuySubController.h"
#import <Masonry.h>

@interface GroupBuyController ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) HDPageViewController *pageViewController;

@end

@implementation GroupBuyController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self hideTabBar];
    [self hideNavigationBar];
}

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
    
    self.titleView = [self addTitleViewWithTitle:@"千县拼团"];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.titleView.mas_bottom).offset(fScreen(2));
    }];
}

- (HDPageViewController *)pageViewController
{
    if (!_pageViewController) {
        
        NSArray *titles = @[@"推荐", @"秒杀团", @"佣金团", @"免单团"];
        NSMutableArray *controllers = [NSMutableArray arrayWithCapacity:4];
        for (NSInteger index = 0; index < 4; index++) {
            GroupBuySubController *groupSubVC = [[GroupBuySubController alloc] initWithGroupType:index];
            groupSubVC.currNavigationController = self.navigationController;
            [controllers addObject:groupSubVC];
        }
        
        CGFloat titleMargin = (kAppWidth - fScreen(48*2) - fScreen(28*11))/3 + 3;
        
        _pageViewController = [[HDPageViewController alloc] initWithFrame:CGRectZero titles:titles titleMargin:titleMargin titleHeight:fScreen(58) firstTitleMargin:fScreen(48) titleFontSize:fScreen(26) controllers:[controllers copy]];
        
        _pageViewController.TitleLineColor = HexColor(0xe44a62);
        _pageViewController.currTitleColor = HexColor(0xe44a62);
        _pageViewController.normalTitleColor = HexColor(0x999999);
    }
    return _pageViewController;
}


@end
