//
//  MYTabBarController.m
//  Huobucuo
//
//  Created by 胡丹 on 16/8/22.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "MYTabBarController.h"

#import "UITabBar+HD.h"

#define kViewControllerCount 6

@interface MYTabBarController ()

@property (nonatomic, strong) NSDictionary *allChildControllersDict;    // 所有的子控制器,一共 4 + 2 = 6个

@end

@implementation MYTabBarController

#pragma mark - Public

+ (MYTabBarController *)sharedTabBarController
{
    static MYTabBarController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MYTabBarController alloc] init];
    });
    return sharedInstance;
}

- (void)setTabBarVisibItem:(MYTabBarVisibStyle)tabBarStyle
{
    if (tabBarStyle == MYTabBarVisibStyleDefault) {
        NSArray *viewControllers = self.viewControllers;
        
        UINavigationController *mainNav = [viewControllers objectAtIndex:0];
        mainNav.title = @"首页";
        
        UINavigationController *categoryNav = [self.allChildControllersDict objectForKey:keyProductCategoriesController];
        UINavigationController *shopCarNav  = [self.allChildControllersDict objectForKey:keyShoppingCarController];
        
        UINavigationController *meNav = [viewControllers objectAtIndex:3];
        meNav.title = @"我的";
        
        NSArray *newViewControllers = @[mainNav, categoryNav, shopCarNav, meNav];
        
        self.viewControllers = newViewControllers;
    }
    else if (tabBarStyle == MYTabBarVisibStyleMine) {
        NSMutableArray *tmpArray = [self.viewControllers mutableCopy];
        
        UINavigationController *mainNav = [tmpArray objectAtIndex:0];
        mainNav.title = @"商城首页";
        tmpArray[1] = [self.allChildControllersDict objectForKey:keyPartnerController];
        tmpArray[2] = [self.allChildControllersDict objectForKey:keyExtensionController];
        
        // tabbar number changes
        
//        if (tmpArray.count == 4) {
//            [tmpArray addObject:[self.allChildControllersDict objectForKey:keyShoppingCarController]];
//        }
        
        
        UINavigationController *meNav = [tmpArray objectAtIndex:3];
        meNav.title = @"我的";
        
        self.viewControllers = [tmpArray copy];
    }
    else if (tabBarStyle == MYTabBarVisibStyleDistributor) {
        NSMutableArray *tmpArray = [self.viewControllers mutableCopy];
        
        UINavigationController *mainNav = [tmpArray objectAtIndex:0];
        mainNav.title = @"商城首页";
        tmpArray[1] = [self.allChildControllersDict objectForKey:keyPartnerController];
        tmpArray[2] = [self.allChildControllersDict objectForKey:keyExtensionController];
        UINavigationController *meNav = [tmpArray objectAtIndex:3];
        meNav.title = @"卖家中心";
        
        self.viewControllers = [tmpArray copy];
    }
    
    [self setItemUI];
}

- (void)setTabBarItemValue:(NSString *)value index:(NSInteger)index
{
    [self.tabBar setBadgValueWithIndex:index number:value backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor]];
}

#pragma mark - life cyele

- (void)viewDidLoad {
    [super viewDidLoad];
 
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initUI];
}


#pragma mark - private

- (void)initUI
{
    [self setItemUI];
}

- (void)setItemUI
{
    NSArray *items = self.tabBar.items;
    
    if (self.itemFontNormalColor) {
        [self setTabBarItemsFontNormalColor:self.itemFontNormalColor items:items];
    }
    if (self.itemFontSelectColor) {
        [self setTabBarItemsFontSelectColor:self.itemFontSelectColor items:items];
    }
    if (self.itemFontSize != 0) {
        [self setTabBarItemsFontSize:self.itemFontSize items:items];
    }
}

- (void)setTabBarItemsFontSize:(CGFloat)fontSize items:(NSArray *)items
{
    for (UITabBarItem *item in items) {
        [item setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.itemFontSize]} forState:UIControlStateNormal];
    }
}

- (void)setTabBarItemsFontNormalColor:(UIColor *)color items:(NSArray *)items
{
    for (UITabBarItem *item in items) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateNormal];
    }
}

- (void)setTabBarItemsFontSelectColor:(UIColor *)color items:(NSArray *)items
{
    for (UITabBarItem *item in items) {
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:color} forState:UIControlStateSelected];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setter

- (void)setAllChilControllersArray:(NSArray *)allChilControllersArray
{
    _allChilControllersArray = allChilControllersArray;
    
    if ([allChilControllersArray count] == kViewControllerCount) {
        NSMutableDictionary *tmpDict = [NSMutableDictionary dictionaryWithCapacity:kViewControllerCount];
        
        [tmpDict setValue:[allChilControllersArray objectAtIndex:0] forKey:keyMainViewController];
        [tmpDict setValue:[allChilControllersArray objectAtIndex:1] forKey:keyProductCategoriesController];
        [tmpDict setValue:[allChilControllersArray objectAtIndex:2] forKey:keyShoppingCarController];
        [tmpDict setValue:[allChilControllersArray objectAtIndex:3] forKey:keyMineController];
        [tmpDict setValue:[allChilControllersArray objectAtIndex:4] forKey:keyPartnerController];
        [tmpDict setValue:[allChilControllersArray objectAtIndex:5] forKey:keyExtensionController];
        
        self.allChildControllersDict = [tmpDict copy];
    }
}

- (void)setItemFontSize:(CGFloat)itemFontSize
{
    _itemFontSize = itemFontSize;
    
    NSArray *items = self.tabBar.items;
    
    if ([items count] > 0) {
        [self setTabBarItemsFontSize:_itemFontSize items:items];
    }
}

- (void)setItemFontNormalColor:(UIColor *)itemFontNormalColor
{
    _itemFontNormalColor = itemFontNormalColor;
    
    NSArray *items = self.tabBar.items;
    
    if ([items count] > 0) {
        [self setTabBarItemsFontNormalColor:_itemFontNormalColor items:items];
    }
}

- (void)setItemFontSelectColor:(UIColor *)itemFontSelectColor
{
    _itemFontSelectColor = itemFontSelectColor;
    
    NSArray *items = self.tabBar.items;
    
    if ([items count] > 0) {
        [self setTabBarItemsFontSelectColor:_itemFontSelectColor items:items];
    }
}

@end
