//
//  ExtensionViewController.m
//  Huobucuo
//
//  Created by hudan on 16/9/8.
//  Copyright © 2016年 胡丹. All rights reserved.
//

#import "ExtensionViewController.h"

#import "MYTabBarController.h"

@implementation ExtensionViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[MYTabBarController sharedTabBarController] setTabBarVisibItem:MYTabBarVisibStyleDistributor];
}

@end
