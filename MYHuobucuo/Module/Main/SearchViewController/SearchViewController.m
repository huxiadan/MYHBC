//
//  SearchViewController.m
//  MYHuobucuo
//
//  Created by hudan on 16/11/1.
//  Copyright © 2016年 hudan. All rights reserved.
//

#import "SearchViewController.h"
#import <Masonry.h>
#import "SearchKeyworkModel.h"

@interface SearchViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTxtField;
@property (nonatomic, strong) UIView *searchHotView;        // 热门搜索
@property (nonatomic, strong) UIScrollView *searchHistoryView;    // 最近搜索

@property (nonatomic, strong) NSArray *keywordArray;    // 元素为字典 key: 关键字  value: 0/1 是否是红色边框
@property (nonatomic, strong) NSArray *historyArray;    // 历史搜索关键词的数组
@property (nonatomic, assign) CGFloat hotViewHeight;    // 热门搜索的高度

@property (nonatomic, copy) NSString *shopId;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requstData];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithShopId:(NSString *)shopId
{
    if (self = [super init]) {
        self.shopId = shopId;
    }
    return self;
}

- (void)requstData
{
    // 热门搜索
    NSMutableArray *tmpKeywordArray = [NSMutableArray arrayWithCapacity:15];
    NSArray *titleArray = @[@"柚子", @"陕西红富士", @"猕猴桃", @"百香果", @"巧克力", @"哇哈哈", @"养乐多", @"乐事", @"金锣火腿", @"西红柿", @"马可波罗", @"西雅图tu", @"帝都", @"魔都", @"阿拉上海人"];
    for (NSInteger index = 0; index < 15; index++) {
        SearchKeyworkModel *model = [[SearchKeyworkModel alloc] init];
        model.titleText = [titleArray objectAtIndex:index];
        model.isRed = index == 7 ? YES : NO;
        [tmpKeywordArray addObject:model];
    }
    
    self.keywordArray = [tmpKeywordArray copy];
    
    // 历史搜索
    self.historyArray = @[@"哆啦A梦", @"百香果", @"德芙", @"英菲尼迪", @"百香果", @"德芙", @"英菲尼迪", @"百香果", @"德芙", @"英菲尼迪", @"百香果", @"德芙", @"英菲尼迪", @"百香果", @"德芙", @"英菲尼迪", @"百香果", @"德芙", @"英菲尼迪"];
}

- (void)initUI
{
    [self.view setBackgroundColor:viewControllerBgColor];
    [self hideTabBar];
    [self hideNavigationBar];
    
    [self addTitleView];
    
    [self addHotSearchKeyWordView];
    
    [self addSearchHistoryView];
}

- (void)addTitleView
{
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(fScreen(40 + 88));
    }];
    self.topView = topView;
    
    [self addSearchView];
    
    UIButton *escButton = [[UIButton alloc] init];
    [escButton setTitle:@"取消" forState:UIControlStateNormal];
    [escButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [escButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [escButton addTarget:self action:@selector(escButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:escButton];
    [escButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(topView.mas_right);
        make.left.equalTo(self.searchView.mas_right).offset(fScreen(2));
        make.centerY.equalTo(self.searchView.mas_centerY);
        make.height.mas_equalTo(fScreen(88));
    }];
}

- (UIView *)addSearchView
{
    UIView *searchView = [[UIView alloc] init];
    [searchView setBackgroundColor:viewControllerBgColor];
    [searchView.layer setCornerRadius:fScreen(10)];
    [self.topView addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).offset(fScreen(28));
        make.right.equalTo(self.topView.mas_right).offset(-fScreen(120));
        make.centerY.equalTo(self.topView.mas_centerY).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(58));
    }];
    self.searchView = searchView;
    
    UIImageView *searchIcon = [[UIImageView alloc] init];
    [searchIcon setImage:[UIImage imageNamed:@"icon)search"]];
    [searchView addSubview:searchIcon];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(fScreen(14));
        make.centerY.equalTo(searchView.mas_centerY);
        make.width.mas_equalTo(fScreen(28));
        make.height.mas_equalTo(fScreen(28));
    }];
    
    UIImageView *arrowIcon = [[UIImageView alloc] init];
    [arrowIcon setImage:[UIImage imageNamed:@"icon_pull"]];
    [searchView addSubview:arrowIcon];
    [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).offset(fScreen(14));
        make.centerY.equalTo(searchIcon.mas_centerY);
        make.width.mas_equalTo(fScreen(18));
        make.height.mas_equalTo(fScreen(18));
    }];
    
    UIButton *cancelButton = [[UIButton alloc] init];
    [cancelButton setImage:[UIImage imageNamed:@"icon_cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(searchView);
        make.width.mas_equalTo(fScreen(20 + 20 + 20));
    }];
    
    UITextField *txtField = [[UITextField alloc] init];
    [txtField setFont:[UIFont systemFontOfSize:fScreen(24)]];
    NSString *placeholderString = @"输入关键词搜索相关商品";
    NSDictionary *attribute = @{NSForegroundColorAttributeName : HexColor(0xcecece)};
    [txtField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholderString attributes:attribute]];
    [searchView addSubview:txtField];
    [txtField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(arrowIcon.mas_right).offset(fScreen(20));
        make.top.bottom.equalTo(searchView);
        make.right.equalTo(cancelButton.mas_left).offset(-fScreen(20));
    }];
    self.searchTxtField = txtField;
    
    return searchView;
}

// 热门搜索视图
- (void)addHotSearchKeyWordView
{
    UIView *searchHotView = [[UIView alloc] init];
    [searchHotView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:searchHotView];
    self.searchHotView = searchHotView;
    
    UIView *hotTitleView = [self makeTitleViewWithIconName:@"icon_hot" titleText:@"热门搜索" superView:searchHotView];
    [hotTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.topView.mas_bottom).offset(fScreen(20));
        make.height.mas_equalTo(fScreen(72));
    }];
    
    // 热门关键词
    UIView *hotKeyWordView = [[UIView alloc] init];
    [hotKeyWordView setBackgroundColor:[UIColor whiteColor]];
    [searchHotView addSubview:hotKeyWordView];
    [hotKeyWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hotTitleView.mas_bottom);
        make.left.right.bottom.equalTo(searchHotView);
    }];
    
    CGFloat x = fScreen(30);
    CGFloat y = fScreen(20);
    for (SearchKeyworkModel *model in self.keywordArray) {
        UIButton *button = [self makeKeywordButtonWithTitle:model.titleText isRed:model.isRed];
        CGSize textSize = [model.titleText sizeForFontsize:fScreen(20)];
        CGFloat btnWidth = textSize.width + 2 + fScreen(10)*2;
        [button addTarget:self action:@selector(keywordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [hotKeyWordView addSubview:button];
        
        CGRect frame = CGRectMake(x, y, btnWidth, fScreen(40));
        [button setFrame:frame];
        
        if (CGRectGetMaxX(frame) + fScreen(20) > kAppWidth) {
            x = fScreen(30);
            y += fScreen(40 + 20);
            frame = CGRectMake(x, y, btnWidth, fScreen(40));
            [button setFrame:frame];
        }
        
        x += btnWidth + fScreen(20);
    }
    
    self.hotViewHeight = y + fScreen(20 + 40) + fScreen(72);
    [searchHotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(fScreen(20));
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.hotViewHeight);
    }];
}

- (UIButton *)makeKeywordButtonWithTitle:(NSString *)title isRed:(BOOL)isRed
{
    UIButton *button = [[UIButton alloc] init];
    [button.titleLabel setFont:[UIFont systemFontOfSize:fScreen(20)]];
    [button setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button.layer setCornerRadius:fScreen(10)];
    [button.layer setBorderColor:isRed ? HexColor(0xe44a62).CGColor : HexColor(0xdadada).CGColor];
    [button.layer setBorderWidth:1.f];
    
    return button;
}

// 最近搜索
- (void)addSearchHistoryView
{
    UIScrollView *searchHistoryView = [[UIScrollView alloc] init];
    [searchHistoryView setBackgroundColor:[UIColor whiteColor]];
    [searchHistoryView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:searchHistoryView];
    self.searchHistoryView = searchHistoryView;
    
    UIView *historyTitleView = [self makeTitleViewWithIconName:@"icon_recently" titleText:@"最近搜索" superView:searchHistoryView];
    [historyTitleView setFrame:CGRectMake(0, 0, kAppWidth, fScreen(72))];   // masonry 在 scrollview 中有问题,使用 setFrame 重新设置一下
    
    CGFloat y = fScreen(72);
    CGFloat cellHeight = fScreen(71);
    for (NSString *keyWord in self.historyArray) {
        UIView *cellView = [self historyCellViewWithText:keyWord];
        [cellView setFrame:CGRectMake(0, y, kAppWidth, cellHeight)];
        [searchHistoryView addSubview:cellView];
        y += cellHeight;
    }
    
    // 清除搜索记录
    UIView *deleteView = [[UIView alloc] init];
    [deleteView setBackgroundColor:[UIColor whiteColor]];
    [searchHistoryView addSubview:deleteView];
    [deleteView setFrame:CGRectMake(0, y, kAppWidth, fScreen(72))];
    [searchHistoryView addSubview:deleteView];
    
    CGSize textSize = [@"清除搜索记录" sizeForFontsize:fScreen(24)];
    
    UIImageView *delIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_del"]];
    [deleteView addSubview:delIcon];
    [delIcon setFrame:CGRectMake((kAppWidth - textSize.width - fScreen(20 + 24))/2, fScreen((72 - 24)/2), fScreen(24), fScreen(24))];
    
    UILabel *delLabel = [[UILabel alloc] init];
    [delLabel setText:@"清除搜索记录"];
    [delLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [delLabel setTextColor:HexColor(0x666666)];
    [delLabel setFrame:CGRectMake(CGRectGetMaxX(delIcon.frame) + fScreen(20), CGRectGetMinY(delIcon.frame), textSize.width + 2, textSize.height)];
    [deleteView addSubview:delLabel];
    
    UIButton *delButton = [[UIButton alloc] init];
    [delButton addTarget:self action:@selector(delHistoryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteView addSubview:delButton];
    [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(deleteView);
    }];
    
    // 历史搜索高度 + 20像素 + 热门搜索高度 + 20像素 + 搜索框高度 是否大于 app 高度
    if ((CGRectGetMaxY(deleteView.frame) +  fScreen(20) + self.hotViewHeight + fScreen(20) + fScreen(40 + 88)) > kAppHeight) {
        [self.searchHistoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchHotView.mas_bottom).offset(fScreen(20));
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    else {
        CGRect frame = CGRectMake(0, fScreen(20) + self.hotViewHeight + fScreen(20) + fScreen(40 + 88), kAppWidth, CGRectGetMaxY(deleteView.frame));
        [self.searchHistoryView setFrame:frame];
    }
    self.searchHistoryView.contentSize = CGSizeMake(0, CGRectGetMaxY(deleteView.frame));
}

- (UIView *)historyCellViewWithText:(NSString *)text
{
    UIView *cellView = [[UIView alloc] init];
    [cellView setBackgroundColor:[UIColor whiteColor]];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [cellView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(cellView);
        make.height.equalTo(@1);
    }];
    
    UIButton *cellButton = [[UIButton alloc] init];
    [cellButton setTitle:text forState:UIControlStateNormal];
    [cellButton.titleLabel setFont:[UIFont systemFontOfSize:fScreen(24)]];
    [cellButton setTitleColor:HexColor(0x666666) forState:UIControlStateNormal];
    cellButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cellButton addTarget:self action:@selector(historyCellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cellView addSubview:cellButton];
    [cellButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(cellView);
        make.left.equalTo(cellView.mas_left).offset(fScreen(30));
    }];
    
    return cellView;
}


/**
 创建关键词和搜索历史的 title 视图

 @param iconName  图标名称
 @param titleText  title 名称
 @param superView 父视图
 */
- (UIView *)makeTitleViewWithIconName:(NSString *)iconName
                           titleText:(NSString *)titleText
                           superView:(UIView *)superView
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:[UIColor whiteColor]];
    [superView addSubview:view];
    
    UIImageView *hotIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    [view addSubview:hotIcon];
    [hotIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30));
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(fScreen(28));
        make.height.mas_equalTo(fScreen(28));
    }];
    
    UILabel *hotTitleLabel = [[UILabel alloc] init];
    [hotTitleLabel setFont:[UIFont systemFontOfSize:fScreen(28)]];
    [hotTitleLabel setTextColor:HexColor(0x999999)];
    [hotTitleLabel setText:titleText];
    [view addSubview:hotTitleLabel];
    [hotTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotIcon.mas_right).offset(fScreen(20));
        make.top.right.bottom.equalTo(view);
    }];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:viewControllerBgColor];
    [view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(fScreen(30));
        make.bottom.right.equalTo(view);
        make.height.equalTo(@1);
    }];
    
    return view;
}

#pragma mark - button click
// 搜索框取消按钮点击
- (void)cancelButtonClick:(UIButton *)sender
{
    [self.searchTxtField setText:@""];
}

// "取消"按钮点击
- (void)escButtonClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 点击热门关键词
- (void)keywordButtonClick:(UIButton *)sender
{
    [self.searchTxtField setText:sender.titleLabel.text];
}

- (void)historyCellButtonClick:(UIButton *)sender
{
    [self.searchTxtField setText:sender.titleLabel.text];
}

// 清空搜索历史
- (void)delHistoryButtonClick:(UIButton *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除搜索记录?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alert show];
}

#pragma mark - alertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 确定删除
        self.historyArray = nil;
        
        for (UIView *subView in self.searchHistoryView.subviews) {
            for (UIView *ssubView in subView.subviews) {
                [ssubView removeFromSuperview];
            }
            [subView removeFromSuperview];
        }
        
        [self.searchHistoryView removeFromSuperview];
        
        [HDUserDefaults setObject:nil forKey:cSearchHistory];
        [HDUserDefaults synchronize];
    }
}

// 添加入历史搜索,已经存在的则前置显示
- (void)setSearchHistoryText:(NSString *)text
{

}

@end
